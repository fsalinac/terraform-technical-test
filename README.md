# 🧪 Terraform + Kubernetes Technical Test

## 📌 Autor  
**Flavio Moisés Salinas Cari**  
Repositorio público: [github.com/fsalinac/terraform-technical-test](https://github.com/fsalinac/terraform-technical-test)

---

## ✅ Objetivo  
El objetivo de esta prueba fue demostrar la capacidad para gestionar infraestructura en Kubernetes usando exclusivamente Terraform, incluyendo la modularización, el despliegue de aplicaciones en contenedores, el uso de Ingress y la integración con Harbor como registry.

---

## 📁 Estructura del Proyecto

```
terraform_technical_flavio.salinas/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── app/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── harbor/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

---

## 🚀 Cómo levantar cada componente

### 1. Clonar el repositorio

```bash
git clone https://github.com/fsalinac/terraform-technical-test.git
cd terraform-technical-test
```

### 2. Configurar tus variables

Edita `variables.tf` para personalizar parámetros como el namespace, nombre de imagen y host:

```hcl
variable "namespace" {
  default = "flavio-salinas"
}

variable "app_name" {
  default = "testapp"
}

variable "image_repository" {
  default = "fmsalinasc/testapp:test"
}

variable "ingress_host" {
  default = "app.miking.duckdns.org"
}
```

### 3. Inicializar Terraform

```bash
terraform init
```

### 4. Aplicar infraestructura de la app

```bash
terraform apply -target=module.app
```

> **Nota:** El módulo Harbor fue estructurado, pero no se desplegó ya que no tenía acceso a la nube para exponer un LoadBalancer real para Harbor. Como solución, utilicé **DockerHub** para almacenar la imagen y no interrumpir la entrega funcional de la prueba.

---

## ✅ Cómo probar el funcionamiento del sistema

### Desde dentro del clúster (valida el despliegue y comunicación):

```bash
kubectl exec -n flavio-salinas -it $(kubectl get pod -n flavio-salinas -l app=testapp -o jsonpath="{.items[0].metadata.name}") -- curl localhost:80
```

### Desde fuera del clúster:

```bash
curl -H "Host: app.miking.duckdns.org" http://<NODE_INTERNAL_IP>:30593
```

Ejemplo con valores reales de mi entorno:

```bash
curl -H "Host: app.miking.duckdns.org" http://10.0.0.100:30593
```

---

## 📌 Supuestos Realizados

- No se tenía acceso total a la nube para exponer puertos públicos, por lo que el Ingress se configuró usando **NodePort**, y se validó con la IP interna del nodo.
- En lugar de Harbor, se utilizó DockerHub para almacenar la imagen (`fmsalinasc/testapp:test`) y no bloquear el flujo de trabajo.
- La aplicación contenida en `app.py` corre en el puerto 80, lo cual fue validado dentro del contenedor y reflejado en el deployment.
- No se incluyó Let’s Encrypt por no contar con un DNS público real con control completo ni acceso a puertos 443 abiertos.
- La base de datos Redis y MariaDB ya estaban preconfiguradas por el entorno (según indicaciones del PDF).

---

## 🧠 Componentes desplegados exitosamente

| Componente                     | Estado       | Notas                                                                 |
|-------------------------------|--------------|-----------------------------------------------------------------------|
| Namespace `flavio-salinas`    | ✅ Completado | Cumple el requerimiento de usar nombre personalizado.                |
| App desplegada (Deployment)   | ✅ Completado | Imagen almacenada en DockerHub.                                      |
| Servicio (ClusterIP)          | ✅ Completado | Conectado correctamente al pod.                                      |
| Ingress Controller            | ✅ Completado | Funciona correctamente con reglas de host/path.                      |
| Comunicación interna          | ✅ Validada   | Se probó conexión a `localhost:80` desde dentro del pod.             |
| Comunicación externa (curl)   | ⚠ Parcial    | Funciona vía NodePort, pero no se expuso con LoadBalancer externo.   |
| Harbor                        | ⚠ No desplegado | Se diseñó el módulo, pero no se desplegó por falta de acceso externo. |

---

## 🧩 Consideraciones Finales

Esta solución fue diseñada y ejecutada exclusivamente por mí, respetando los límites del entorno disponible. Los elementos que no se completaron fueron únicamente por falta de acceso de red para exposición pública, no por desconocimiento técnico .
El uso de DockerHub se dio para mitigar errores internos al momento de desplegar Hardor dado que este presento problemas de recursos al momento de su despliegue y por las limitantes del tiempo y la idea de lograr el objetivo final (tener una aplicaciones funcional y demostrar los conocimientos requeridos en la prueba). 
No se logro exponer la comunicacion externa debido a limitaciones cloud . Durante la implementación de la prueba, se configuró el Ingress Controller (ingress-nginx) con tipo NodePort, exponiendo los puertos necesarios (80 y 443) en el clúster. Internamente, se validó correctamente el acceso a la aplicación mediante peticiones HTTP direccionadas al Node IP y NodePort, lo cual demuestra que la infraestructura y la aplicación están operativas dentro del entorno Kubernetes.
Sin embargo, para que la aplicación sea accesible desde el exterior (por ejemplo, desde un navegador en internet), es necesario que la máquina donde está desplegado el clúster tenga una IP pública expuesta y que se encuentren configuradas reglas de red o de firewall (Security Groups) que permitan el acceso externo a los puertos asignados (como el 30593).
Dado que no se cuenta con acceso administrativo a la infraestructura de red en la nube, no fue posible configurar la exposición externa de manera segura. Esta limitación fue considerada para no comprometer la estabilidad del entorno ni interferir con la configuración existente del proveedor.

