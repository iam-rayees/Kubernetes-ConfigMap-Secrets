# ☸️ Mastering Kubernetes: ConfigMaps & Secrets 🔐
A deep dive into managing configurations and sensitive data in real-time Kubernetes setups.

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![ConfigMaps](https://img.shields.io/badge/Kubernetes_ConfigMaps-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Secrets](https://img.shields.io/badge/Kubernetes_Secrets-6A5ACD?style=for-the-badge&logo=kubernetes&logoColor=white)
![Configuration](https://img.shields.io/badge/Configuration-4B6584?style=for-the-badge&logo=kubernetes&logoColor=white)

---

## 🚀 Introduction

In any real-time Kubernetes (K8s) deployment, hardcoding configurations and sensitive data directly into your container images or Pod manifests is a huge anti-pattern. Not only does it make your application rigid and harder to update, but it also creates severe security vulnerabilities. 

This directory demonstrates the power of **ConfigMaps** and **Secrets**—the Kubernetes native way to decouple configuration artifacts and sensitive information from application code securely. 

---

## 📄 ConfigMaps: The Configuration Engine

**What are ConfigMaps?**
ConfigMaps are Kubernetes API objects used to store non-confidential data in key-value pairs. They allow you to decouple environment-specific configuration from your container images, making your applications easily portable across different environments (Dev, Staging, Prod).

**Why are ConfigMaps critical?**
- **Dynamic Updates:** Change application configuration without rebuilding your Docker images.
- **Portability & Reusability:** Keep your container image identical but behave differently depending on the ConfigMap injected dynamically at runtime.
- **Flexibility:** Store entire configuration files (like `nginx.conf`) or simple environmental variables.

### 🛠️ Practical Example: Nginx Custom Configuration

In this lab, we inject a custom Nginx configuration file (`default.conf`) directly into an Nginx web server deployment using a ConfigMap.

**1. Create the ConfigMap directly from a file:**
```bash
kubectl create configmap default.conf --from-file=default.conf
```

**2. Verify the ConfigMap creation:**
```bash
kubectl get cm
kubectl describe cm default.conf
```

**3. Mounting inside a Deployment (`cm-deploy.yaml`):**
```yaml
      volumes:
        - name: nginxconfvol
          configMap:
            name: default.conf
```

---

## 🔐 Secrets: Guarding the Gate

**What are Secrets?**
Secrets are similar to ConfigMaps but are specifically designed to hold sensitive information, such as passwords, OAuth tokens, and SSH keys. Storing confidential data in a Secret is far safer and more flexible than putting it verbatim in a Pod definition or a container image.

**Why do Secrets play an essential role in real-time setups?**
- **Enhanced Security:** Ensures sensitive data is base64 encoded and can be natively encrypted at rest in `etcd`.
- **Granular Access Control:** Role-Based Access Control (RBAC) mechanisms can be easily applied to Secrets, ensuring that only authorized Pods and Users can read or manipulate them.
- **Secure Integrations:** Critical for pulling images from private registries (e.g., Docker Hub or AWS ECR), authenticating with enterprise databases securely, dispensing TLS certificates, and reliably injecting Cloud IAM credentials (like AWS Access keys) into active Pods.

### 🛠️ Real-world usage of Secrets in Action

#### 1. Image Pull Secrets for Private Registries
To securely pull a custom Docker image from a private registry, we generate a `docker-registry` Secret:
```bash
kubectl create secret docker-registry docker-pwd \ 
  --docker-server=docker.io \
  --docker-username=abcdef \
  --docker-password=XXXXXXXXXXXXXXXX \
  --docker-email=mohdrayees1234@gmail.com
```
*In our `deployment.yaml`, this secret is transparently referenced utilizing `imagePullSecrets: [ { name: "docker-pwd" } ]`*

#### 2. Generic Secrets for Database Authentication
Securely store standard database usernames and passwords:
```bash
kubectl create secret generic db-user --from-literal=username=devuser
kubectl create secret generic db-pass --from-literal=password='S!B\*d$zDsb='
```
*To decode and verify values selectively without exposing them natively:*
```bash
kubectl get secret db-user -o jsonpath="{.data.username}" | base64 --decode
```

#### 3. Defining Secrets as Environment Variables
As illustrated in `secret-deploy-env.yaml`, AWS credentials are base64 encoded intrinsically, stored, and then injected dynamically as environment variables into a Pod orchestrating the `awscli`.
```yaml
            - name: AWS_ACCESS_KEY_ID
              valueFrom:
                secretKeyRef:
                  name: aws-access-keys
                  key: AWS_ACCESS_KEY_ID
```

#### 4. Mounting Secrets as Direct Content Files
Alternatively, instead of utilizing environment variables, the AWS credentials file can be securely mounted physically as a file mapped on the container's isolated file system (`/root/.aws/credentials`) as seen in `fileMount.yaml`.

---

## 🎮 Hands-on Commands Cheat Sheet

Here are some of the primary, most powerful commands utilized efficiently throughout this setup:

| Task | Command |
|------|---------|
| Create a Deployment from a manifests | `kubectl apply -f deployment.yaml` |
| View active Pods | `kubectl get pods` |
| Investigate specific Pod details | `kubectl describe pod <pod_name>` |
| View cluster Secrets | `kubectl get secrets` |
| Describe a specific Secret explicitly | `kubectl describe secrets aws-access-keys` |
| Exec locally into a Pod container for validating/testing | `kubectl exec -it <pod-name> -- bash` |
| Delete a defined robust resource | `kubectl delete -f deployment.yaml` |
| Expose a working Deployment utilizing NodePort | `kubectl expose deployment newnginx --port 80 --target-port 9999 --type NodePort` |

---
## 🎯 Conclusion

ConfigMaps and Secrets are indispensable for building flexible, secure, and production-ready deployments. By decoupling configurations and sensitive data from code, they ensure robust and scalable Kubernetes environments.