// on backend

```
sudo docker run -d \
  --name employee-backend \
  -p 8080:8080 \
  -e DB_HOST=172.17.0.1 \
  -e DB_USER=postgres \
  -e DB_PASSWORD=admin123 \
  -e DB_NAME=employeedb \
  -e DB_PORT=5432 \
  -e ALLOWED_ORIGINS=http://localhost:3000 \
  employee-backend


sudo docker container stop de65a027ae0d
sudo docker container rm de65a027ae0d

http://3.88.235.188:8080/employees
http://3.88.235.188:8080/

curl -X POST http://18.204.224.252:8080/employees   -H "Content-Type: application/json"   -d '{
    "employee_id": 101,
    "name": "Atul Kamble"
}'

curl http://18.204.224.252:8080/employees
```
// on docker
```
sudo docker build -t samikshav/full-stack-app-frontend:latest .
sudo docker push samikshav/full-stack-app-frontend:latest 

sudo docker build -t samikshav/full-stack-app-backend:latest .
sudo docker push samikshav/full-stack-app-backend:latest 
```
// docker compose 
```
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose version
sudo docker-compose up --build
```
// minikube 
```
# Update packages
sudo yum update -y
sudo yum install git -y
git clone https://github.com/Samiksha998/project.git
cd project 

sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
docker --version


curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm

sudo usermod -aG docker $USER && newgrp docker
sudo usermod -aG docker ec2-user

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"   
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
# and then append (or prepend) ~/.local/bin to $PATH

kubectl version --client

minikube start
kubectl apply -f kubectl apply -f k8s-deploy.yaml 
minikube addons enable metrics-server

```
// Optional-Troubleshooting 
```
curl http://54.242.238.216:30036
curl http://54.242.238.216:30080


sudo iptables -L -n
sudo ufw status
sudo ufw allow 30036
sudo ufw allow 30080
kubectl get nodes -o wide
kubectl get svc frontend-service backend-service -o wide

sudo nano /etc/systemd/system/k3s.service
--node-external-ip=<http://54.242.238.216/
ExecStart=/usr/local/bin/k3s server --node-external-ip=54.242.238.216
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart k3s

sudo minikube tunnel
kubectl get svc frontend-service backend-service
kubectl port-forward svc/frontend-service 3000:3000
kubectl port-forward svc/backend-service 8080:8080
```
