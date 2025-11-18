String formattedDate() {
  var date = DateTime.now();
  const days = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo',
  ];

  const months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  final weekDay = days[date.weekday - 1];
  final day = date.day;
  final month = months[date.month - 1];
  final anho = date.year;

  return "$weekDay $day de $month del $anho";
}
