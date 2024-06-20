List allcitysRus = [
  {'cityname': 'Alcalá de Henares'},
  {'cityname': 'Alicante'},
  {'cityname': 'Badalona'},
  {'cityname': 'Barcelona'},
  {'cityname': 'Bilbao'},
  {'cityname': 'Cartagena'},
  {'cityname': 'Córdoba'},
  {'cityname': 'Elche'},
  {'cityname': 'Gijón'},
  {'cityname': 'Granada'},
  {'cityname': 'Jerez de la Frontera'},
  {'cityname': 'La Coruña'},
  {'cityname': 'Las Palmas de Gran Canaria'},
  {'cityname': 'L’Hospitalet de Llobregat'},
  {'cityname': 'Madrid'},
  {'cityname': 'Málaga'},
  {'cityname': 'Móstoles'},
  {'cityname': 'Murcia'},
  {'cityname': 'Oviedo'},
  {'cityname': 'Palma'},
  {'cityname': 'Santa Cruz de Tenerife'},
  {'cityname': 'Sabadell'},
  {'cityname': 'Sevilla'},
  {'cityname': 'Tarrasa'},
  {'cityname': 'Valencia'},
  {'cityname': 'Valladolid'},
  {'cityname': 'Vigo'},
  {'cityname': 'Vitoria'},
  {'cityname': 'Zaragoza'},
];
List popularcitys = [
  {'cityname': 'Barcelona'},
  {'cityname': 'Madrid'},
  {'cityname': 'Sevilla'},
  {'cityname': 'Valencia'},
  {'cityname': 'Zaragoza'},
];
Map allcitysList = {
  'citys': allcitysRus,
};


Map spheresList = {
  'spheres': spheres,
};

List spheres = [
  {'id': 1001, 'name': 'Обмен валюты', 'podspheres': false},
  {'id': 1002, 'name': 'Еда', 'podspheres': true},
  {'id': 1003, 'name': 'Авто, трансфер и перевозки', 'podspheres': false},
  {'id': 1004, 'name': 'Красота и здоровье', 'podspheres': false},
  {'id': 1005, 'name': 'Консультационные услуги', 'podspheres': false},
  {'id': 1006, 'name': 'Ремонт и строительство', 'podspheres': false},
  {'id': 1007, 'name': 'Домашний персонал', 'podspheres': false},
  {'id': 1008, 'name': 'Фрилансеры', 'podspheres': false},
  {'id': 1009, 'name': 'Обучение', 'podspheres': false},
  {'id': 1010, 'name': 'Недвижимость', 'podspheres': false},
  {'id': 1011, 'name': 'Продажа готового бизнеса', 'podspheres': false},
  {'id': 1012, 'name': 'Спорт', 'podspheres': false},
  {'id': 1013, 'name': 'Развлечения и мероприятия', 'podspheres': false},
  {'id': 1014, 'name': 'Домашние животные', 'podspheres': false},
  {'id': 1015, 'name': 'Туризм', 'podspheres': false},
  {'id': 1016, 'name': 'Дети', 'podspheres': false},
  {'id': 1017, 'name': 'Продажа личных вещей', 'podspheres': false},
];

Map PodSphere = {
  'eat': {
    'list': [
      {'name': 'Доставка готовой еды', 'id': 9999},
      {'name': 'Доставка полуфабрикатов', 'id': 9999},
      {'name': 'Повар', 'id': 9999},
      {'name': 'Кондитер', 'id': 9999},
    ]
  }
};

Map cat = {
  'categories': [
    {'id': 1001, 'name': 'Обмен валюты', 'subcategories': []},
    {
      'id': 1002,
      'name': 'Еда',
      'subcategories': [
        {'name': 'Доставка готовой еды', 'id': 2001, 'subcategories': []},
        {'name': 'Доставка полуфабрикатов', 'id': 2002, 'subcategories': []},
        {'name': 'Повар', 'id': 2003, 'subcategories': []},
        {'name': 'Кондитер', 'id': 2004, 'subcategories': []},
      ]
    },
    {
      'id': 1003,
      'name': 'Авто, трансфер и перевозки',
      'subcategories': [
        {'name': 'Доставка готовой еды', 'id': 2001, 'subcategories': []},
        {'name': 'Доставка полуфабрикатов', 'id': 2002, 'subcategories': []},
        {'name': 'Повар', 'id': 2003, 'subcategories': []},
        {'name': 'Кондитер', 'id': 2004, 'subcategories': []},
      ]
    },
    {
      'id': 1004,
      'name': 'Красота и здоровье',
      'subcategories': [
        {'name': 'Доставка готовой еды', 'id': 2001, 'subcategories': []},
        {'name': 'Доставка полуфабрикатов', 'id': 2002, 'subcategories': []},
        {'name': 'Повар', 'id': 2003, 'subcategories': []},
        {'name': 'Кондитер', 'id': 2004, 'subcategories': []},
      ]
    },
    {
      'id': 1005,
      'name': 'Консультационные услуги',
      'subcategories': [
        {'name': 'Доставка готовой еды', 'id': 2001, 'subcategories': []},
        {
          'name': 'Доставка полуфабрикатов',
          'id': 2002,
          'subcategories': [
            {'id': 1007, 'name': 'Домашний персонал', 'subcategories': []},
            {'id': 1008, 'name': 'Фрилансеры', 'subcategories': []},
          ]
        },
        {'name': 'Повар', 'id': 2003, 'subcategories': []},
        {'name': 'Кондитер', 'id': 2004, 'subcategories': []},
      ]
    },
    {'id': 1006, 'name': 'Ремонт и строительство', 'subcategories': []},
    {'id': 1007, 'name': 'Домашний персонал', 'subcategories': []},
    {'id': 1008, 'name': 'Фрилансеры', 'subcategories': []},
    {'id': 1009, 'name': 'Обучение', 'subcategories': []},
    {'id': 1010, 'name': 'Недвижимость', 'subcategories': []},
    {'id': 1011, 'name': 'Продажа готового бизнеса', 'subcategories': []},
    {'id': 1012, 'name': 'Спорт', 'subcategories': []},
    {'id': 1013, 'name': 'Развлечения и мероприятия', 'subcategories': []},
    {'id': 1014, 'name': 'Домашние животные', 'subcategories': []},
    {'id': 1015, 'name': 'Туризм', 'subcategories': []},
    {'id': 1016, 'name': 'Дети', 'subcategories': []},
    {'id': 1017, 'name': 'Продажа личных вещей', 'subcategories': []},
  ],
};
