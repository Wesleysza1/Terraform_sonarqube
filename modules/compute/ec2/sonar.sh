#!/bin/bash
set +e  # Desativa falha automática do script ao ocorrer erro

# Função para verificar o código de saída de um comando e registrar o status
check_status() {
    if [ $? -eq 0 ]; then
        echo "$1: Executado com sucesso."
    else
        echo "$1: Falhou."
    fi
}

# Atualização e instalação de pacotes
sudo apt update
sudo apt upgrade -y
sudo apt install unzip -y
check_status "Atualização de pacotes"

# Instalação do AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
check_status "Instalação do AWS CLI"

# Configuração do PostgreSQL
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/pgdg.asc &>/dev/null
sudo apt update
sudo apt-get -y install postgresql postgresql-contrib
sudo systemctl enable postgresql
check_status "Instalação do PostgreSQL"

# Configuração do PostgreSQL com Senhas
psql_password=$(aws secretsmanager get-secret-value --secret-id sonarqube/postgresql --query SecretString --output text | jq -r .password)
sonar_password=$(aws secretsmanager get-secret-value --secret-id sonarqube/postgresql/user/sonar --query SecretString --output text | jq -r .password)

sudo apt-get install -y expect
expect << EOF
spawn sudo passwd postgres
expect "Nova senha:"
send "$psql_password\r"
expect "Redigite a nova senha:"
send "$psql_password\r"
expect eof
EOF
check_status "Configuração de senha do usuário postgres"

# Criação do usuário e banco de dados PostgreSQL
su - postgres <<EOSQL
createuser sonar
psql <<SQL
ALTER USER sonar WITH ENCRYPTED PASSWORD '$sonar_password';
CREATE DATABASE sonarqube OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
\q
SQL
EOSQL
check_status "Criação do usuário e banco de dados PostgreSQL"

# Instalação do Java
sudo apt install -y openjdk-17-jdk
check_status "Instalação do Java"

# Configurações do sistema
LIMITS_CONF="/etc/security/limits.conf"
SYSCTL_CONF="/etc/sysctl.conf"

if ! grep -q "^sonarqube.*nofile.*65536" "$LIMITS_CONF"; then
    echo "Adicionando sonarqube - nofile 65536 em $LIMITS_CONF"
    echo "sonarqube   -   nofile   65536" | sudo tee -a "$LIMITS_CONF"
fi
if ! grep -q "^sonarqube.*nproc.*4096" "$LIMITS_CONF"; then
    echo "Adicionando sonarqube - nproc 4096 em $LIMITS_CONF"
    echo "sonarqube   -   nproc    4096" | sudo tee -a "$LIMITS_CONF"
fi
if ! grep -q "^vm.max_map_count.*262144" "$SYSCTL_CONF"; then
    echo "Adicionando vm.max_map_count = 262144 em $SYSCTL_CONF"
    echo "vm.max_map_count = 262144" | sudo tee -a "$SYSCTL_CONF"
fi
sudo sysctl -p
check_status "Configurações de limite do sistema"

# Instalação do SonarQube
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.6.0.92116.zip
sudo unzip sonarqube-10.6.0.92116.zip -d /opt
sudo mv /opt/sonarqube-10.6.0.92116 /opt/sonarqube
sudo groupadd sonar
sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonar sonar
sudo chown sonar:sonar /opt/sonarqube -R
check_status "Instalação do SonarQube"

# Configuração do SonarQube
SONAR_PROPERTIES="/opt/sonarqube/conf/sonar.properties"
if ! grep -q "^sonar.jdbc.username=sonar" "$SONAR_PROPERTIES"; then
    echo "sonar.jdbc.username=sonar" | sudo tee -a "$SONAR_PROPERTIES"
fi
if ! grep -q "^sonar.jdbc.password=" "$SONAR_PROPERTIES"; then
    echo "sonar.jdbc.password=$sonar_password" | sudo tee -a "$SONAR_PROPERTIES"
else
    sudo sed -i "s/^sonar.jdbc.password=.*/sonar.jdbc.password=$sonar_password/" "$SONAR_PROPERTIES"
fi
if ! grep -q "^sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube" "$SONAR_PROPERTIES"; then
    echo "sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube" | sudo tee -a "$SONAR_PROPERTIES"
fi
check_status "Configuração do SonarQube"

# Criação do arquivo de serviço systemd para SonarQube
SERVICE_FILE="/etc/systemd/system/sonar.service"
sudo tee "$SERVICE_FILE" > /dev/null <<EOL
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOL
#sudo systemctl daemon-reload
sudo systemctl enable sonar.service
sudo systemctl start sonar
check_status "Configuração do serviço SonarQube"