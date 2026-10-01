import 'turkey_locations.dart';

// Bulgaria's 28 provinces (oblasti) by ISO 3166-2:BG code, with their 265
// municipalities (obshtini). Sofia City is listed by its 24 districts (rayoni),
// which are more useful for meeting in person. Each entry is 'Latin|Кирилица';
// profiles and listings store the Latin name.

const _data = <(int, String, List<String>)>[
  (1, 'Blagoevgrad|Благоевград', ['Bansko|Банско', 'Belitsa|Белица', 'Blagoevgrad|Благоевград', 'Garmen|Гърмен', 'Gotse Delchev|Гоце Делчев', 'Hadzhidimovo|Хаджидимово', 'Kresna|Кресна', 'Petrich|Петрич', 'Razlog|Разлог', 'Sandanski|Сандански', 'Satovcha|Сатовча', 'Simitli|Симитли', 'Strumyani|Струмяни', 'Yakoruda|Якоруда']),
  (2, 'Burgas|Бургас', ['Aytos|Айтос', 'Burgas|Бургас', 'Kameno|Камено', 'Karnobat|Карнобат', 'Malko Tarnovo|Малко Търново', 'Nesebar|Несебър', 'Pomorie|Поморие', 'Primorsko|Приморско', 'Ruen|Руен', 'Sozopol|Созопол', 'Sredets|Средец', 'Sungurlare|Сунгурларе', 'Tsarevo|Царево']),
  (3, 'Varna|Варна', ['Aksakovo|Аксаково', 'Avren|Аврен', 'Beloslav|Белослав', 'Byala|Бяла', 'Dalgopol|Дългопол', 'Devnya|Девня', 'Dolni Chiflik|Долни чифлик', 'Provadiya|Провадия', 'Suvorovo|Суворово', 'Valchi Dol|Вълчи дол', 'Varna|Варна', 'Vetrino|Ветрино']),
  (4, 'Veliko Tarnovo|Велико Търново', ['Elena|Елена', 'Gorna Oryahovitsa|Горна Оряховица', 'Lyaskovets|Лясковец', 'Pavlikeni|Павликени', 'Polski Trambesh|Полски Тръмбеш', 'Strazhitsa|Стражица', 'Suhindol|Сухиндол', 'Svishtov|Свищов', 'Veliko Tarnovo|Велико Търново', 'Zlataritsa|Златарица']),
  (5, 'Vidin|Видин', ['Belogradchik|Белоградчик', 'Boynitsa|Бойница', 'Bregovo|Брегово', 'Chuprene|Чупрене', 'Dimovo|Димово', 'Gramada|Грамада', 'Kula|Кула', 'Makresh|Макреш', 'Novo Selo|Ново село', 'Ruzhintsi|Ружинци', 'Vidin|Видин']),
  (6, 'Vratsa|Враца', ['Borovan|Борован', 'Byala Slatina|Бяла Слатина', 'Hayredin|Хайредин', 'Kozloduy|Козлодуй', 'Krivodol|Криводол', 'Mezdra|Мездра', 'Miziya|Мизия', 'Oryahovo|Оряхово', 'Roman|Роман', 'Vratsa|Враца']),
  (7, 'Gabrovo|Габрово', ['Dryanovo|Дряново', 'Gabrovo|Габрово', 'Sevlievo|Севлиево', 'Tryavna|Трявна']),
  (8, 'Dobrich|Добрич', ['Balchik|Балчик', 'Dobrich|Добрич', 'Dobrichka|Добричка', 'General Toshevo|Генерал Тошево', 'Kavarna|Каварна', 'Krushari|Крушари', 'Shabla|Шабла', 'Tervel|Тервел']),
  (9, 'Kardzhali|Кърджали', ['Ardino|Ардино', 'Chernoochene|Черноочене', 'Dzhebel|Джебел', 'Kardzhali|Кърджали', 'Kirkovo|Кирково', 'Krumovgrad|Крумовград', 'Momchilgrad|Момчилград']),
  (10, 'Kyustendil|Кюстендил', ['Boboshevo|Бобошево', 'Bobov Dol|Бобов дол', 'Dupnitsa|Дупница', 'Kocherinovo|Кочериново', 'Kyustendil|Кюстендил', 'Nevestino|Невестино', 'Rila|Рила', 'Sapareva Banya|Сапарева баня', 'Treklyano|Трекляно']),
  (11, 'Lovech|Ловеч', ['Apriltsi|Априлци', 'Letnitsa|Летница', 'Lovech|Ловеч', 'Lukovit|Луковит', 'Teteven|Тетевен', 'Troyan|Троян', 'Ugarchin|Угърчин', 'Yablanitsa|Ябланица']),
  (12, 'Montana|Монтана', ['Berkovitsa|Берковица', 'Boychinovtsi|Бойчиновци', 'Brusartsi|Брусарци', 'Chiprovtsi|Чипровци', 'Georgi Damyanovo|Георги Дамяново', 'Lom|Лом', 'Medkovets|Медковец', 'Montana|Монтана', 'Valchedram|Вълчедръм', 'Varshets|Вършец', 'Yakimovo|Якимово']),
  (13, 'Pazardzhik|Пазарджик', ['Batak|Батак', 'Belovo|Белово', 'Bratsigovo|Брацигово', 'Lesichovo|Лесичово', 'Panagyurishte|Панагюрище', 'Pazardzhik|Пазарджик', 'Peshtera|Пещера', 'Rakitovo|Ракитово', 'Sarnitsa|Сърница', 'Septemvri|Септември', 'Strelcha|Стрелча', 'Velingrad|Велинград']),
  (14, 'Pernik|Перник', ['Breznik|Брезник', 'Kovachevtsi|Ковачевци', 'Pernik|Перник', 'Radomir|Радомир', 'Tran|Трън', 'Zemen|Земен']),
  (15, 'Pleven|Плевен', ['Belene|Белене', 'Cherven Bryag|Червен бряг', 'Dolna Mitropoliya|Долна Митрополия', 'Dolni Dabnik|Долни Дъбник', 'Gulyantsi|Гулянци', 'Iskar|Искър', 'Knezha|Кнежа', 'Levski|Левски', 'Nikopol|Никопол', 'Pleven|Плевен', 'Pordim|Пордим']),
  (16, 'Plovdiv|Пловдив', ['Asenovgrad|Асеновград', 'Brezovo|Брезово', 'Hisarya|Хисаря', 'Kaloyanovo|Калояново', 'Karlovo|Карлово', 'Krichim|Кричим', 'Kuklen|Куклен', 'Laki|Лъки', 'Maritsa|Марица', 'Parvomay|Първомай', 'Perushtitsa|Перущица', 'Plovdiv|Пловдив', 'Rakovski|Раковски', 'Rodopi|Родопи', 'Sadovo|Садово', 'Saedinenie|Съединение', 'Sopot|Сопот', 'Stamboliyski|Стамболийски']),
  (17, 'Razgrad|Разград', ['Isperih|Исперих', 'Kubrat|Кубрат', 'Loznitsa|Лозница', 'Razgrad|Разград', 'Samuil|Самуил', 'Tsar Kaloyan|Цар Калоян', 'Zavet|Завет']),
  (18, 'Ruse|Русе', ['Borovo|Борово', 'Byala|Бяла', 'Dve Mogili|Две могили', 'Ivanovo|Иваново', 'Ruse|Русе', 'Slivo Pole|Сливо поле', 'Tsenovo|Ценово', 'Vetovo|Ветово']),
  (19, 'Silistra|Силистра', ['Alfatar|Алфатар', 'Dulovo|Дулово', 'Glavinitsa|Главиница', 'Kaynardzha|Кайнарджа', 'Silistra|Силистра', 'Sitovo|Ситово', 'Tutrakan|Тутракан']),
  (20, 'Sliven|Сливен', ['Kotel|Котел', 'Nova Zagora|Нова Загора', 'Sliven|Сливен', 'Tvarditsa|Твърдица']),
  (21, 'Smolyan|Смолян', ['Banite|Баните', 'Borino|Борино', 'Chepelare|Чепеларе', 'Devin|Девин', 'Dospat|Доспат', 'Madan|Мадан', 'Nedelino|Неделино', 'Rudozem|Рудозем', 'Smolyan|Смолян', 'Zlatograd|Златоград']),
  (22, 'Sofia City|София (столица)', ['Bankya|Банкя', 'Iskar|Искър', 'Ilinden|Илинден', 'Izgrev|Изгрев', 'Krasna Polyana|Красна поляна', 'Krasno Selo|Красно село', 'Kremikovtsi|Кремиковци', 'Lozenets|Лозенец', 'Lyulin|Люлин', 'Mladost|Младост', 'Nadezhda|Надежда', 'Novi Iskar|Нови Искър', 'Oborishte|Оборище', 'Ovcha Kupel|Овча купел', 'Pancharevo|Панчарево', 'Poduyane|Подуяне', 'Serdika|Сердика', 'Slatina|Слатина', 'Sredets|Средец', 'Studentski|Студентски', 'Triaditsa|Триадица', 'Vazrazhdane|Възраждане', 'Vitosha|Витоша', 'Vrabnitsa|Връбница']),
  (23, 'Sofia Province|Софийска област', ['Anton|Антон', 'Botevgrad|Ботевград', 'Bozhurishte|Божурище', 'Chavdar|Чавдар', 'Chelopech|Челопеч', 'Dolna Banya|Долна баня', 'Dragoman|Драгоман', 'Elin Pelin|Елин Пелин', 'Etropole|Етрополе', 'Godech|Годеч', 'Gorna Malina|Горна Малина', 'Ihtiman|Ихтиман', 'Koprivshtitsa|Копривщица', 'Kostenets|Костенец', 'Kostinbrod|Костинброд', 'Mirkovo|Мирково', 'Pirdop|Пирдоп', 'Pravets|Правец', 'Samokov|Самоков', 'Slivnitsa|Сливница', 'Svoge|Своге', 'Zlatitsa|Златица']),
  (24, 'Stara Zagora|Стара Загора', ['Bratya Daskalovi|Братя Даскалови', 'Chirpan|Чирпан', 'Galabovo|Гълъбово', 'Gurkovo|Гурково', 'Kazanlak|Казанлък', 'Maglizh|Мъглиж', 'Nikolaevo|Николаево', 'Opan|Опан', 'Pavel Banya|Павел баня', 'Radnevo|Раднево', 'Stara Zagora|Стара Загора']),
  (25, 'Targovishte|Търговище', ['Antonovo|Антоново', 'Omurtag|Омуртаг', 'Opaka|Опака', 'Popovo|Попово', 'Targovishte|Търговище']),
  (26, 'Haskovo|Хасково', ['Dimitrovgrad|Димитровград', 'Harmanli|Харманли', 'Haskovo|Хасково', 'Ivaylovgrad|Ивайловград', 'Lyubimets|Любимец', 'Madzharovo|Маджарово', 'Mineralni Bani|Минерални бани', 'Simeonovgrad|Симеоновград', 'Stambolovo|Стамболово', 'Svilengrad|Свиленград', 'Topolovgrad|Тополовград']),
  (27, 'Shumen|Шумен', ['Hitrino|Хитрино', 'Kaolinovo|Каолиново', 'Kaspichan|Каспичан', 'Nikola Kozlevo|Никола Козлево', 'Novi Pazar|Нови пазар', 'Shumen|Шумен', 'Smyadovo|Смядово', 'Varbitsa|Върбица', 'Veliki Preslav|Велики Преслав', 'Venets|Венец']),
  (28, 'Yambol|Ямбол', ['Bolyarovo|Болярово', 'Elhovo|Елхово', 'Straldzha|Стралджа', 'Tundzha|Тунджа', 'Yambol|Ямбол']),
];

String _latin(String pair) => pair.split('|').first;
String _cyrillic(String pair) => pair.split('|').last;

final List<Province> bulgarianProvinces = [
  for (final (code, name, districts) in _data)
    Province(
      code,
      _latin(name),
      [for (final d in districts) _latin(d)],
      localName: _cyrillic(name),
      localDistricts: {for (final d in districts) _latin(d): _cyrillic(d)},
    ),
];
