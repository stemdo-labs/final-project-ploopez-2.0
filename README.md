# final-project-ploopez


Pasos para la puesta en ejecución del proyecto
1. Desplegar Terraform Completo 

                ![alt text](capturas/image-4.png)

2. Una vez desplegado terraform, creamos el self hosted runner en la máquina virtual 2

                ![alt text](capturas/image-5.png)

3. Ejecutar el workflow de ansible utilizando el self hosted runner creado en el paso anterior 

                ![alt text](capturas/image-6.png)

4. Posteriormente, copiamos laa password generada por el ACR y se pega en la variable correspondiente dentro del environment
5. Ejecutamos el Workflow del ACR get credentials y el kubectl generate secret para que el cluster pueda conectaarse al ACR

                ![alt text](capturas/image-7.png)

6. Subimos la imagen de nuestra Aplicación PHP al ACR 
7. Ejecutamos el kubectl apply de los deployments, services, configmaps que sean requeridos 

                ![alt text](capturas/image-8.png)

8. Obtenemos la IP del Load Balancer que nos permitirá conectarnos al cluster y, por consiguiente,a la aplicación

                ![alt text](capturas/image-9.png)

9. Acceder a la IP y Realizar la compra de entradas.

                ![alt text](capturas/image-10.png)

                ![alt text](capturas/image-11.png)


* Funcionalidades a parte de la ejecución normal del proyecto * 

    - Copias de seguridad diarias 
    - Plan de recuperación de los datos en caso de fallo o desastre
    - Destrucción del entorno automatizada
    

