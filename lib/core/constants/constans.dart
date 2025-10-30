const kwebUrl = "https://www.sen.gov.py";

//Messages
const kUnknownErrorMessage =
    "Ocurrió un error desconocido. Por favor, intente nuevamente más tarde.";
const kSinRecomendacioensMessage = "No hay recomendaciones disponibles.";

// default city

const kDefaultCity = "Asunción";

// lists of departments and cities

const kDepartmentsList = [
  'Asunción',
  'Central',
  'Alto Paraná',
  'Itapúa',
  'Cordillera',
  'Guairá',
  'Caaguazú',
  'Caazapá',
  'Concepción',
  'San Pedro',
  'Paraguarí',
  'Amambay',
  'Canindeyú',
  'Presidente Hayes',
  'Boquerón',
  'Alto Paraguay',
];

const kCitiesListOfCapital = [
  'Asunción',
  'Luque',
  'San Lorenzo',
  'Capiatá',
  'Lambaré',
  'Fernando de la Mora',
  'Villa Elisa',
  'Ñemby',
  'Itauguá',
  'Areguá',
];

/*private val departamentoToCiudadMap = mapOf(
        "boqueron" to "Mariscal José Félix Estigarribia",
        "boquerón" to "Mariscal José Félix Estigarribia",
        "alto paraguay" to "Fuerte Olimpo",
        "amambay" to "Pedro Juan Caballero",
        "presidente hayes" to "Pozo Colorado",
        "pte hayes" to "Pozo Colorado",
        "pte. hayes" to "Pozo Colorado",
        "concepcion" to "Concepción",
        "concepción" to "Concepción",
        "san pedro" to "San Pedro",
        "canindeyu" to "Salto del Guairá",
        "canindeyú" to "Salto del Guairá",
        "asuncion" to "Asunción",
        "asunción" to "Asunción",
        "central" to "Asunción",
        "paraguari" to "Paraguarí",
        "paraguarí" to "Paraguarí",
        "guaira" to "Villarrica",
        "guairá" to "Villarrica",
        "caaguazu" to "Coronel Oviedo",
        "caaguazú" to "Coronel Oviedo",
        "alto parana" to "Ciudad del Este",
        "alto paraná" to "Ciudad del Este",
        "ñeembucu" to "Pilar",
        "ñeembucú" to "Pilar",
        "misiones" to "San Juan Bautista",
        "caazapa" to "Caazapá",
        "caazapá" to "Caazapá",
        "itapua" to "Encarnación",
        "itapúa" to "Encarnación",
        "cordillera" to "Caacupé"
    )

*/

const kMainCities = [
  "Mariscal José Félix Estigarribia",
  "Fuerte Olimpo",
  "Pedro Juan Caballero",
  "Pozo Colorado",
  "Concepción",
  "San Pedro",
  "Salto del Guairá",
  "Asunción",
  "Paraguarí",
  "Villarrica",
  "Coronel Oviedo",
  "Ciudad del Este",
  "Pilar",
  "San Juan Bautista",
  "Caazapá",
  "Encarnación",
  "Caacupé",
];

const KCitiesList = [
  {"boqueron": "Mariscal José Félix Estigarribia"},
  {"boquerón": "Mariscal José Félix Estigarribia"},
  {"alto paraguay": "Fuerte Olimpo"},
  {"amambay": "Pedro Juan Caballero"},
  {"presidente hayes": "Pozo Colorado"},
  {"pte hayes": "Pozo Colorado"},
  {"pte. hayes": "Pozo Colorado"},
  {"concepcion": "Concepción"},
  {"concepción": "Concepción"},
  {"san pedro": "San Pedro"},
  {"canindeyu": "Salto del Guairá"},
  {"canindeyú": "Salto del Guairá"},
  {"asuncion": "Asunción"},
  {"asunción": "Asunción"},
  {"central": "Asunción"},
  {"paraguari": "Paraguarí"},
  {"paraguarí": "Paraguarí"},
  {"guaira": "Villarrica"},
  {"guairá": "Villarrica"},
  {"caaguazu": "Coronel Oviedo"},
  {"caaguazú": "Coronel Oviedo"},
  {"alto parana": "Ciudad del Este"},
  {"alto paraná": "Ciudad del Este"},
  {"ñeembucu": "Pilar"},
  {"ñeembucú": "Pilar"},
  {"misiones": "San Juan Bautista"},
  {"caazapa": "Caazapá"},
  {"caazapá": "Caazapá"},
  {"itapua": "Encarnación"},
  {"itapúa": "Encarnación"},
  {"cordillera": "Caacupé"},
];
