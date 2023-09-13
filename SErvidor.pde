import hypermedia.net.*;
UDP udp; 
String[] log = {},nombre= {},apellido= {},mensaje= {};
color[] col={};
String local = "192.168.100.3";
//formato <Nombre- apellido - mensaje>

void setup() {
size(600,600);
  udp = new UDP( this, 6000 );
  udp.listen( true );
  udp.log(true);
   
  textAlign(LEFT, CENTER); 
}

void draw() {
  background(0);
  fill(0,255, 0); textSize(24);
  text("Server en: " + local + " Puerto: 6000 ", 50, 20);
  textSize(18);
  for (int i = 0; i < log.length; i++) {
    float y = 100 + i * (60); 
    fill(col[i]); 
    text(nombre[i] +" " + apellido[i]+"\n" + mensaje[i], 50, y); 
  }

}

 

void receive( byte[] data, String ip, int port ) {    
  
  data = subset(data, 0, data.length);
  String message = new String( data );
  
  if(log.length >= 8){
      String[] nuevoArreglo = new String[log.length - 1];  
      arrayCopy(log, 1, nuevoArreglo, 0, log.length - 1);  
      log = nuevoArreglo;
      String[] nuevoArreglo1 = new String[nombre.length - 1];  
      arrayCopy(nombre, 1, nuevoArreglo1, 0, nombre.length - 1);  
      nombre = nuevoArreglo1;
      String[] nuevoArreglo2 = new String[apellido.length - 1];  
      arrayCopy(apellido, 1, nuevoArreglo2, 0, apellido.length - 1);  
      apellido = nuevoArreglo2;
      String[] nuevoArreglo3 = new String[mensaje.length - 1];  
      arrayCopy(mensaje, 1, nuevoArreglo3, 0, mensaje.length - 1);  
      mensaje = nuevoArreglo3;
      color[] nuevoArreglo4 = new color[col.length - 1];  
      arrayCopy(col, 1, nuevoArreglo4, 0, col.length - 1);  
      col = nuevoArreglo4;
  }
  
  
  
  if (message.indexOf('<') != -1 && message.indexOf('>') != -1){
    String origen = message;
    
     message = message.replace(Character.toString('<'), "");
     message = message.replace(Character.toString('>'), "");
     String[] fragment = split(message, '-');
     if(fragment.length != 3){
        udp.send( "Error de formato", ip, port );
        return;
     }
     nombre = append(nombre, fragment[0]);
     apellido = append(apellido, fragment[1]);
     mensaje = append(mensaje, fragment[2]);
     log = append(log, origen);
     col = append(col, color(random(0,255), random(0,255), random(0,255)));
     udp.send( "Aprobado, consulte servidor", ip, port );
     
  }else{
     udp.send( "Trama ilegigle", ip, port );
    
  }
 
}
