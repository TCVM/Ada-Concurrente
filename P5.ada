1.  Se requiere modelar un puente de un único sentido que soporta hasta 5 unidades de peso.
    El peso de los vehículos depende del tipo: cada auto pesa 1 unidad, cada camioneta pesa 2
    unidades y cada camión 3 unidades. Suponga que hay una cantidad innumerable de
    vehículos (A autos, B camionetas y C camiones). Analice el problema y defina qué tareas,
    recursos y sincronizaciones serán necesarios/convenientes para resolverlo.
    
    a. Realice la solución suponiendo que todos los vehículos tienen la misma prioridad.
    
    b. Modifique la solución para que tengan mayor prioridad los camiones que el resto de los
       vehículos.

    a)

    Procedure Puente is
    
        Task Barrera is
            Entry Auto();
            Entry Camioneta();
            Entry Camion();
            Entry Salir(p:IN Integer);
        End Barrera;
   
        Task Type Vehiculo;
   
        Task Body Vehiculo is
            if("Es auto")then
                Barrera.Auto();
                Barrera.Salir(1);
            elseif("Es camioneta")then
                Barrera.Camioneta();
                Barrera.Salir(2);
            else
               Barrera.Camion();
               Barrera.Salir(3);
            end if;
        End Vehiculo;

        Task Body Barrera is
                peso:integer = 5;
            Begin
                loop
                    SELECT
                        when((peso-3>=0)and(Camion'count>0))=> 
                            accept Camion() do
                                peso-=3;
                            End Camion;
                    OR
                        when((peso-2>=0)and(Camioneta'count>0))=>
                            accept Camioneta() do
                                peso-=2;
                            End Camioneta;
                    OR
                        when((peso-1>=0)and(Auto'count>0))=>
                            accept Autos() do
                                peso-=1;
                            End autos;
                    OR
                        accept Salir(p:IN integer)do
                            peso+=p;
                        End Salir;
                    END SELECT;
            end loop;
        End Barrera;

    arrAuto:array(1..A) of Vehiculo;
    arrCamioneta:array(1..B) of Vehiculo;
    arrCamion:array(1..C) of Vehiculo;

    Begin
        null;
    End Puente;

    b)

    #Me parece extraño que si hay camiones en la cola ningun otro vehiculo pueda avanzar,
    #se que es por prioridad pero si hay camiones en la cola y no hay suficiente capacidad
    #de peso para dejarlos pasar entonces todos los procesos se quedan esperando a que los
    #camiones pasen aunque para el resto de los vehiculos la capacidad alcance

    Procedure Puente is
    
        Task Barrera is
            Entry Auto();
            Entry Camioneta();
            Entry Camion();
            Entry Salir(p:IN Integer);
        End Barrera;
   
        Task Type Vehiculo;
   
        Task Body Vehiculo is
            if("Es auto")then
                Barrera.Auto();
                Barrera.Salir(1);
            elseif("Es camioneta")then
                Barrera.Camioneta();
                Barrera.Salir(2);
            else
               Barrera.Camion();
               Barrera.Salir(3);
            end if;
        End Vehiculo;

        Task Body Barrera is
                peso:integer = 5;
            Begin
                loop
                    SELECT
                        when((peso-3>=0)and(Camion'count>0))=> 
                            accept Camion() do
                                peso-=3;
                            End Camion;
                    OR
                        when((peso-2>=0)and(Camion'count==0)and(Camioneta'count>0))=>
                            accept Camioneta() do
                                peso-=2;
                            End Camioneta;
                    OR
                        when((peso-1>=0)and(Camion'count==0)and(Auto'count>0))=>
                            accept Autos() do
                                peso-=1;
                            End autos;
                    OR
                        accept Salir(p:IN integer)do
                            peso+=p;
                        End Salir;
                    END SELECT;
            end loop;
        End Barrera;

    arrAuto:array(1..A) of Vehiculo;
    arrCamioneta:array(1..B) of Vehiculo;
    arrCamion:array(1..C) of Vehiculo;

    Begin
        null;
    End Puente;

2.  Se quiere modelar el funcionamiento de un banco, al cual llegan clientes que deben realizar
    un pago y retirar un comprobante. Existe un único empleado en el banco, el cual atiende de
    acuerdo con el orden de llegada.
    
    a) Implemente una solución donde los clientes llegan y se retiran sólo después de haber sido
       atendidos.
    
    b) Implemente una solución donde los clientes se retiran si esperan más de 10 minutos para
       realizar el pago.
    
    c) Implemente una solución donde los clientes se retiran si no son atendidos
       inmediatamente.
    
    d) Implemente una solución donde los clientes esperan a lo sumo 10 minutos para ser
       atendidos. Si pasado ese lapso no fueron atendidos, entonces solicitan atención una vez más
       y se retiran si no son atendidos inmediatamente.


    a)
        Procedure Banco is

            Task Empleado is
                Entry Pedido(pago:IN double,comprobante:OUT txt);
            End Empleado;

            Task Type Cliente;

            arrCliente:array(1..N) of Cliente;

            Task Body Empleado is
                comprobante:txt;
            Begin
                loop
                    accept Pedido(pago:IN double,comprobante:OUT txt)do
                        comprobante=atenderPago(pago);
                    end Pedido;
                End loop;
            End Empleado;

            Task Body Cliente is
                pago:double;
                comprobante:txt;
            Begin
                Empleado.Pedido(pago,comprobante);
            End Cliente;

        Begin
            null;
        End Banco;

    b)

          Procedure Banco is

            Task Empleado is
                Entry Pedido(pago:IN double,comprobante:OUT txt);
            End Empleado;

            Task Type Cliente;

            arrCliente:array(1..N) of Cliente;

            Task Body Empleado is
                comprobante:txt;
            Begin
                loop
                    accept Pedido(pago:IN double,comprobante:OUT txt)do
                        comprobante=atenderPago(pago);
                    end Pedido;
                End loop;
            End Empleado;

            Task Body Cliente is
                pago:double;
                comprobante:txt;
            Begin
                SELECT
                    Empleado.Pedido(pago,comprobante);
                OR DELAY 600
                    null;
                END SELECT;
            End Cliente;

        Begin
            null;
        End Banco;

    c)

          Procedure Banco is

            Task Empleado is
                Entry Pedido(pago:IN double,comprobante:OUT txt);
            End Empleado;

            Task Type Cliente;

            arrCliente:array(1..N) of Cliente;

            Task Body Empleado is
                comprobante:txt;
            Begin
                loop
                    accept Pedido(pago:IN double,comprobante:OUT txt)do
                        comprobante=atenderPago(pago);
                    end Pedido;
                End loop;
            End Empleado;

            Task Body Cliente is
                pago:double;
                comprobante:txt;
            Begin
                SELECT 
                    Empleado.Pedido(pago,comprobante);
                ELSE #OR ?
                    null;
                END SELECT;
            End Cliente;

        Begin
            null;
        End Banco;
    
    d)

          Procedure Banco is

            Task Empleado is
                Entry Pedido(pago:IN double,comprobante:OUT txt);
            End Empleado;

            Task Type Cliente;

            arrCliente:array(1..N) of Cliente;

            Task Body Empleado is
                comprobante:txt;
            Begin
                loop
                    accept Pedido(pago:IN double,comprobante:OUT txt)do
                        comprobante=atenderPago(pago);
                    end Pedido;
                End loop;
            End Empleado;

            Task Body Cliente is
                pago:double;
                comprobante:txt;
            Begin
                SELECT
                    Empleado.Pedido(pago,comprobante);
                OR DELAY 600
                    SELECT 
                        Empleado.Pedido(pago,comprobante);
                    ELSE
                        null;
                    END SELECT;
                END SELECT;
            End Cliente;

        Begin
            null;
        End Banco;

3.  Se dispone de un sistema compuesto por 1 central y 2 procesos periféricos, que se
    comunican continuamente. Se requiere modelar su funcionamiento considerando las
    siguientes condiciones:
    - La central siempre comienza su ejecución tomando una señal del proceso 1; luego
    toma aleatoriamente señales de cualquiera de los dos indefinidamente. Al recibir una
    señal de proceso 2, recibe señales del mismo proceso durante 3 minutos.
    - Los procesos periféricos envían señales continuamente a la central. La señal del
    proceso 1 será considerada vieja (se deshecha) si en 2 minutos no fue recibida. Si la
    señal del proceso 2 no puede ser recibida inmediatamente, entonces espera 1 minuto y
    vuelve a mandarla (no se deshecha).

    Procedure Sistema is
    Task Central is
        Entry Señal1();
        Entry Señal2(); 
        Entry Terminar();
    End Central;

    Task Periferico1;
    Task Periferico2;

    Task Contador is
        Entry Comenzar();
    End Contador;

    Task Body Central is
    fin:boolean;
    Begin
        accept Señal1(Señal);
        loop
            SELECT 
                accept Señal1(Señal);
            OR
                accept Señal2(Señal);
                Contador.Comenzar();
                fin=false;
                while(fin==false)loop
                    SELECT 
                        when(Terminar'count==0)=> accept Señal2(Señal);
                    OR
                        accept Terminar() do fin=true;
                End loop;
            End SELECT;
        End loop;
    End Central;

    Task Body Contador is
    Begin
        loop
            accept Comenzar()do
                DELAY 180
            End Comenzar;
            central.Terminar();
        End loop;
        
    End Contador;

    Task Body Periferico1 is
    Begin
        loop
            Señal=generarSeñal();
            SELECT 
                Central.Señal1(Señal);
            OR DELAY 120
                null;
            End SELECT
        End loop;
    End Periferico1;

    Task Body Periferico2 is
    Begin
        Señal=generarSeñal();
        loop
            SELECT 
                Central.Señal2(Señal);
                Señal=generarSeñal();
            OR DELAY 60
                null;
            End SELECT
        End loop;
    End Periferico2;
    
    Begin
        null;
    END Sistema;

4.  En una clínica existe un médico de guardia que recibe continuamente peticiones de
    atención de las E enfermeras que trabajan en su piso y de las P personas que llegan a la
    clínica ser atendidos.
    Cuando una persona necesita que la atiendan espera a lo sumo 5 minutos a que el médico lo
    haga, si pasado ese tiempo no lo hace, espera 10 minutos y vuelve a requerir la atención del
    médico. Si no es atendida tres veces, se enoja y se retira de la clínica.
    Cuando una enfermera requiere la atención del médico, si este no lo atiende inmediatamente
    le hace una nota y se la deja en el consultorio para que esta resuelva su pedido en el
    momento que pueda (el pedido puede ser que el médico le firme algún papel). Cuando la
    petición ha sido recibida por el médico o la nota ha sido dejada en el escritorio, continúa
    trabajando y haciendo más peticiones.

    El médico atiende los pedidos dándole prioridad a los enfermos que llegan para ser atendidos.
    Cuando atiende un pedido, recibe la solicitud y la procesa durante un cierto tiempo. Cuando
    está libre aprovecha a procesar las notas dejadas por las enfermeras.

    Procedure Clinica is
    
    Task Medico is
        Entry AtencionEnfermo();
        Entry AtencionEnfermera();
        Entry Solicitud(nota:IN txt,res:OUT txt);
    End Medico;

    Task Type Enfermera;

    Task Type Persona;

    Task Type Escritorio is
        Entry Pedido(nota:IN txt);
        Entry Solicitud(nota:OUT txt);
    End Escritorio; #Por que es necesario? todo el mundo lo hizo

    ArrEnfermera:array(1..E) of Enfermera;
    arrPersona:array(1..P) of Persona;

    Task Body Persona is
    terminar:boolean;=false;
    cont:integer=0;
    Begin
        while(terminar==false)loop
            SELECT  
                Medico.AtencionEnfermo();
                terminar=true;
            OR DELAY 300
                DELAY 600
                    if(cont<3)then
                        cont+=1;
                    else terminar=true;
                    end if;
            End SELECT;
        End loop;
    End Persona;

    Task Body Enfemera is
        nota:txt;
    Begin
        loop
            SELECT Medico.AtencionEnfermera();
            ELSE
                nota=generarNota();
                Escritorio.Pedido(nota);
        End loop;
    End Enfermera;

    Task Body Medico is
    Begin
        loop
            SELECT
                accept AtencionEnfermo() do
                    Atender();
                End AtencionEnfermo;
            OR
                when(AtencionEnfermo'count == 0)=>
                    SELECT
                        accept AtencionEnfermera() do
                            Atender);
                            #delay por x tiempo?
                        End AtencionEnferema;
                    ELSE #OR == ELSE? Es no deterministico el SELECT?
                        SELECT Escritorio.Solicitud(nota:IN integer)do
                                    ResolverPedido(nota);
                                End Solicitud;
                        ELSE
                            null;
                        End SELECT;
                    End SELECT;
            End SELECT;
        End loop;
    End Medico;

    Task Body Escritorio is
    notas:cola;
    Begin
        loop
            SELECT
                accept Pedido(nota:IN txt)do
                    notas.push(nota);
                End Pedido;
            OR
                when(!notas.isEmpty())=>
                    accept Solicitud(nota:OUT txt)do
                        nota=notas.pop();
                    End Solicitud;
            End SELECT;
        End loop;
    End Escritorio;

    Begin
        null;
    End Clinica;    


 ?) En un sistema para acreditar carreras universitarias, hay UN Servidor que atiende pedidos
    de U Usuarios de a uno a la vez y de acuerdo con el orden en que se hacen los pedidos.
    Cada usuario trabaja en el documento a presentar, y luego lo envía al servidor; espera la
    respuesta de este que le indica si está todo bien o hay algún error. Mientras haya algún error,
    vuelve a trabajar con el documento y a enviarlo al servidor. Cuando el servidor le responde
    que está todo bien, el usuario se retira. Cuando un usuario envía un pedido espera a lo sumo
    2 minutos a que sea recibido por el servidor, pasado ese tiempo espera un minuto y vuelve a
    intentarlo (usando el mismo documento).

    Procedure Sistema is
    
    Task Servidor is
        Entry Pedido(tp:IN txt,res:OUT boolean);
    End Servidor;

    Task Type Usuario;

    arrUsuario:array(1..U) of Usuario;

    Task Body Usuario is
        tp:txt;
        res:boolean=false;
    Begin
        TrabajarDocumento(TP);
        while(res==false)loop
            SELECT 
                Servidor.Pedido(tp,res);
                if(res==false)then
                    tp=CorregirTP(tp);
                End if;
            OR DELAY 120
                DELAY 60;
        End loop;
    End Usuario;

    Task Body Servidor is
        res:boolean=false;
    Begin
        loop
            accept Pedido(tp:IN txt,res:OUT boolean)do
                res=corregirTP(tp);
            End Pedido;
        End loop;
    End Servidor;

    Begin
    End Sistema;

5. En una playa hay 5 equipos de 4 personas cada uno (en total son 20 personas donde cada
   una conoce previamente a que equipo pertenece). Cuando las personas van llegando
   esperan con los de su equipo hasta que el mismo esté completo (hayan llegado los 4
   integrantes), a partir de ese momento el equipo comienza a jugar. El juego consiste en que
   cada integrante del grupo junta 15 monedas de a una en una playa (las monedas pueden ser
   de 1, 2 o 5 pesos) y se suman los montos de las 60 monedas conseguidas en el grupo. Al
   finalizar cada persona debe conocer el grupo que más dinero junto. Nota: maximizar la
   concurrencia. Suponga que para simular la búsqueda de una moneda por parte de una
   persona existe una función Moneda() que retorna el valor de la moneda encontrada.

   Procedure Playa is

   Task Type Equipo is
        Entry ident(id:IN integer);
        Entry Llegue();
        Entry Barrera();
        Entry RecibirMonedas(monedas:IN integer);
        Entry Ganador(ganador:OUT Integer);
   End Equipo;

   Task Type Persona;

    Task Admin is
        Entry CalcularTotal(monedas:IN integer);
        Entry AnunciarGanador(ganador:OUT Integer);
    End Admin;

    arrPersona:array(1..20) of Persona;
    arrEquipo:array(1..4) of Equipo;

    Task Body Equipo is
        id:integer;
        monedasValor:integer=0;
        ganador:integer;
    Begin
        accept ident(idE:IN integer)do
            id=idE;
        End ident;
        for i in 1..5 loop
            accept Llegue();
        End loop;
        for i in 1..5 loop
            accept Barrera();
        End loop;

        for i in 1..5 loop
            accept RecibirMonedas(m:IN integer)do
                monedasValor+=m;
            End RecibirMonedas;
        End loop;
        
        Admin.CalcularTotal(monedasValor);
        Admin.AnunciarGanador(ganador);

        for i in 1..5 loop
            accept Ganador(g:OUT integer)do
                g=ganador;
            End Ganador;
        End loop;
    End Equipo;

    Task Body Persona is
        equipo:...;ganador:integer;monedas:integer=0;
    Begin
        Equipo[equipo].Llegue();
        Equipo[equipo].Barrera();
        for i in 1..15 loop
            monedas+=Moneda();
        End loop;
        Equipo[equipo].RecibirMonedas(monedas);
        Equipo[equipo].Ganador(ganador);
    End Persona;

    Task Admin is
        total:integer=0;
        ganador:integer;
    Begin
        for i in 1..4 loop
            accept CalcularTotal(m:IN integer)do
                total+=m;
            End CalcularTotal;
        End loop;
        G=max_index(total)
        for i in 1..4 loop
            accept AnunciarGanador(ganador:OUT integer)do
                ganador=G;
            End AnunciarGanador;
        End loop;
    End Admin;

   Begin
    for i in 1..4 loop
        arrEquipo[i].ident(i);
    End loop;
   End Playa;

6.  Se debe calcular el valor promedio de un vector de 1 millón de números enteros que se
    encuentra distribuido entre 10 procesos Worker (es decir, cada Worker tiene un vector de
    100 mil números). Para ello, existe un Coordinador que determina el momento en que se
    debe realizar el cálculo de este promedio y que, además, se queda con el resultado. Nota:
    maximizar la concurrencia; este cálculo se hace una sola vez.

    Procedure Calculo is
        Task Coordinador is
            Entry Empezar();
            Entry RecibirCuentas(suma:IN integer);
        End Coordinador;
    
        Task Type Worker;

        arrWorker:array[1..10]of Worker;

        Task Body Coordinador is
        total:integer=0;promedio:double;
        Begin 
            for i in 1..10 loop
                accept Empezar();
            End loop;
            for i in 1..10 loop
                accept RecibirCuentas(suma:IN integer)do
                    total+=suma;
                End RecibirCuentas;
            End loop;
            promedio=total/1000000;
        End Coordinador;
        
        Task Body Worker is
            suma:integer=0;
            arrNumeros:array[1..100000] of integer;
        Begin
            Coordinador.Empezar();
            for i in 1..100000 loop
                suma+=arrNumeros[i];
            End loop;
            Coordinador.RecibirCuentas(suma);
        End Worker;
    Begin
        null;
    End Calculo;

7. Hay un sistema de reconocimiento de huellas dactilares de la policía que tiene 8 Servidores
   para realizar el reconocimiento, cada uno de ellos trabajando con una Base de Datos propia;
   a su vez hay un Especialista que utiliza indefinidamente. El sistema funciona de la siguiente
   manera: el Especialista toma una imagen de una huella (TEST) y se la envía a los servidores
   para que cada uno de ellos le devuelva el código y el valor de similitud de la huella que más
   se asemeja a TEST en su BD; al final del procesamiento, el especialista debe conocer el
   código de la huella con mayor valor de similitud entre las devueltas por los 8 servidores.
   Cuando ha terminado de procesar una huella comienza nuevamente todo el ciclo. Nota:
   suponga que existe una función Buscar(test, código, valor) que utiliza cada Servidor donde
   recibe como parámetro de entrada la huella test, y devuelve como parámetros de salida el
   código y el valor de similitud de la huella más parecida a test en la BD correspondiente.
   Maximizar la concurrencia y no generar demora innecesaria

   Procedure Sistema is
   
    Task Especialista is
        Entry AnalizarHuella(TEST:OUT txt);
        Entry devolverTEST(codigo:OUT integer,valor:OUT integer);
    End Especialista;

    Task Type Servidor;
    
    arrServidores:array[1..8]of Servidor;

    Task Body Servidor is
        codigo,valor:integer;
    Begin
        loop
            Especialista.AnalizarHuella(test);
            buscar(Test,codigo,valor);
            Especialista.devolverTEST(codigo,valor);
        End loop;
    End Servidor;

    Task Body Especialista is
        TEST:txt;codigo,valor,max,cmax:integer;
        arrRes:array[1..8]of integer;
    Begin
        for i in 1..8 loop
            accept AnalizarHuella(TEST:OUT txt)do
                TEST=TEST;
            End AnalizarHuella;
        End loop;
        for i in 1..8 loop
            accept devolverTEST(codigo:IN integer,valor:IN integer)do
                if(valor>max)then 
                    valor=max;
                    cmax=codigo;
                End if;
            End devolverTEST;
        End loop;
    End;
   Begin
    null;
   End Sistema;

8.  Una empresa de limpieza se encarga de recolectar residuos en una ciudad por medio de 3
    camiones. Hay P personas que hacen reclamos continuamente hasta que uno de los camiones pase 
    por su casa. Cada persona hace un reclamo y espera a lo sumo 15 minutos a que llegue un camión; 
    si no pasa, vuelve a hacer el reclamo y a esperar a lo sumo 15 minutos a que llegue un camión; y 
    así sucesivamente hasta que el camión llegue y recolecte los residuos. Sólo cuando un camión llega, 
    es cuando deja de hacer reclamos y se retira. Cuando un camión está libre la empresa lo envía a la 
    casa de la persona que más reclamos ha hecho sin ser atendido. Nota: maximizar la concurrencia.

    (Los ultimos 2 robe bastante, son las 8 am, dejame en paz)

    Procedure Residuos is
        Task Type Camion;

        Task Empresa is
            Entry recibirReclamo(id:IN integer);
            Entry Limpiar();
        End Empresa;

        Task Type Persona is
            Entry ident(id:IN integer);
            Entry recibir();
        End Persona;

        arrPersona:array[1..P]of Persona;
        arrCamion:array[1..3]of Camion;
    
        Task Body Empresa is
            arrReclamos:array[1..P] of integer;
            cont:integer=0;
        Begin
            loop
                SELECT 
                    accept recibirReclamo(id:IN integer)do
                        if(arrReclamos[id]!=-1)
                        arrReclamos[id]++;
                        cont++;
                    End recibirReclamo;
                OR
                    when(cont>0)accept Siguiente(max OUT integer)do
                        max=max(arrReclamos[]);
                        cont-=arrReclamos[id];
                        arrReclamos[id]=-1;
                    End Siguiente;
            End loop;
        End Empresa;

        Task Body Camion is
            loop
                Empresa.Siguiente(id);
                Limpiar(id);
                arrPersonas[i].recibir();
            End loop;
        End Camion;

        Task Body Persona is
                id:integer;
                fin:boolean=false;
            Begin
                accept ident(id IN integer)do
                    id=id;
                End ident;
                while(fin==false)loop
                    Empresa.RecibirReclamo(id);
                    SELECT 
                        accept recibir()do
                            fin=true;
                        End recibir;
                    OR DELAY 900
                        null;
                    End SELECT;
                End loop;
            End;
        End Persona;

    Begin
        for i in 1..P loop
            Persona[i].Ident(i);
        End loop;
    End Residuos;
