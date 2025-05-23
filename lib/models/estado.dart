enum EstadoTipo {proceso,finalizado}

class Estado {
  final int id;
  final EstadoTipo nuevoEstado;
  

  Estado({
    required this.id,
    required this.nuevoEstado,
    
  });

  Map<String, dynamic> toJson() => {
    'home_schedule_id': id,
    'home_schedule_state': nuevoEstado.toString().split('.').last,
  };
}
