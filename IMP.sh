kubectl create secret docker-registry docker-pwd \
--docker-server=docker.io --docker-username=rayeez \
--docker-password= \
--docker-email=mohdrayees1234@gmail.com 

kubectl create secret generic db-user --from-literal=username=
kubectl create secret generic db-pass --from-literal=password=

ku get secrets

kubectl get secret db-user -o jsonpath="{.data.username}" | base64 --decode
kubectl get secret db-pass -o jsonpath="{.data.password}" | base64 --decode

echo -n  | base64
echo -n  | base64


