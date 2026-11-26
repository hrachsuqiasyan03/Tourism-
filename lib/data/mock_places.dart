import '../models/place.dart';
final List<City> cities = [

  // ============================================================
  // YEREVAN
  // ============================================================

  City(//Done
    id: 1,
    name: 'Երևան',
    region: 'Երևան',
    description:
    'Հայաստանի մայրաքաղաքը և ամենամեծ քաղաքը, հայտնի է իր պատմությամբ, թանգարաններով, ճարտարապետությամբ և մշակութային գրավչություններով:',
    imagePath: 'assets/images/regions/Yerevan.jpg',
    latitude: 40.186503,
    longitude: 44.528342,
    places: [
      Place(
        id: 1,
        name: 'Հանրապետության հրապարակ',
        type: 'հուշահամալիր',
        description:
        'Երևանի կենտրոնական հրապարակը, որը շրջապատված է կարևոր կառավարական և մշակութային շենքերով:',
        imagePath: 'assets/images/places/Republic_square.jpg',
        latitude: 40.1776,
        longitude: 44.5126,
        rating: 4.9,
      ),
      Place(
        id: 2,
        name: 'Կասկադի համալիր',
        type: 'հուշահամալիր',
        description:
        'Հուշարծան սանդուղք և արվեստի համալիր, որը առաջարկում է Երևանի պանորամային տեսարաններ:',
        imagePath: 'assets/images/places/Cascade.jpg',
        latitude: 40.1895,
        longitude: 44.5155,
        rating: 4.9,
      ),
      Place(
        id: 3,
        name: 'Մատենադարան',
        type: 'թանգարան',
        description:
        'Համաշխարհային հայտնի հնագույն հայկական ձեռագրերի պահպանման կենտրոն:',
        imagePath: 'assets/images/places/Matenadaran.jpg',
        latitude: 40.1920,
        longitude: 44.5211,
        rating: 4.9,
      ),
      Place(
        id: 4,
        name: 'Ծիծեռնակաբերդ',
        type: 'հուշահամալիր',
        description:
        'Հայոց ցեղասպանության զոհերի հիշատակին նվիրված հուշահամալիր:',
        imagePath: 'assets/images/places/Tsitsernakaberd.jpg',
        latitude: 40.1869,
        longitude: 44.4915,
        rating: 4.9,
      ),
      Place(
        id: 5,
        name: 'Էրեբունի թանգարան',
        type: 'թանգարան',
        description:
        'Թանգարան և հնագիտական վայր, կապված հնագույն Էրեբունի քաղաքի հետ:',
        imagePath: 'assets/images/places/Erebuni_museum.jpg',
        latitude: 40.1473,
        longitude: 44.5340,
        rating: 4.8,
      ),
    ],
  ),

  // ============================================================
  // ARAGATSOTN
  // ============================================================

  City(//Done
    id: 2,
    name: 'Աշտարակ',
    region: 'Արագածոտն',
    description:
    'Պատմական քաղաք, որը հայտնի է միջնադարյան եկեղեցիներով և Քասաղի կիրճով:',
    imagePath: 'assets/images/regions/Ashtarak.jpg',
    latitude: 40.2989,
    longitude: 44.3611,
    places: [
      Place(
        id: 6,
        name: 'Կարմրավոր եկեղեցի',
        type: 'եկեղեցի',
        description:
        'Փոքր և գեղեցիկ պահպանված միջնադարյան հայկական եկեղեցի:',
        imagePath: 'assets/images/places/Karmravor_church.jpg',
        latitude: 40.3006,
        longitude: 44.3629,
        rating: 4.8,
      ),
      Place(
        id: 7,
        name: 'Քասաղի կիրճ',
        type: 'կիրճ',
        description:
        'Բնական կիրճ, որը անցնում է Աշտարակի միջով:',
        imagePath: 'assets/images/places/Kasagh_gorge.jpg',
        latitude: 40.3000,
        longitude: 44.3600,
        rating: 4.8,
      ),
      Place(
        id: 8,
        name: 'Սաղմոսավանք',
        type: 'վանք',
        description:
        'Միջնադարյան վանք, որը գտնվում է Քասաղ գետի կիրճի վերևում:',
        imagePath: 'assets/images/places/Saghmosavank.jpg',
        latitude: 40.3480, // VERIFY
        longitude: 44.3740,
        rating: 4.9,
      ),
      Place(
        id: 9,
        name: 'Հովհաննավանք',
        type: 'վանք',
        description:
        'Պատմական վանք, որը գտնվում է Քասաղի կիրճի վերևում:',
        imagePath: 'assets/images/places/Hovhannavank.jpg',
        latitude: 40.3410, // VERIFY
        longitude: 44.3660,
        rating: 4.9,
      ),
    ],
  ),

  City(//Done
    id: 3,
    name: 'Ապարան',
    region: 'Արագածոտն',
    description:
    'Լեռնային քաղաք, որը շրջապատված է բնական լանդշաֆտներով և պատմական հուշարձաններով:',
    imagePath: 'assets/images/regions/Aparan.jpg',
    latitude: 40.5946,
    longitude: 44.3589,
    places: [
      Place(
        id: 10,
        name: 'Ապարանի ջրամբար',
        type: 'գետ',
        description:
        'Գեղատեսիլ ջրամբար, որը շրջապատված է լեռներով:',
        imagePath: 'assets/images/places/Aparan_reservoir.jpg',
        latitude: 40.6130, // VERIFY
        longitude: 44.3850,
        rating: 4.7,
      ),
      Place(
        id: 11,
        name: 'Քասաղի բազիլիկ',
        type: 'եկեղեցի',
        description:
        'Կարևոր վաղ միջնադարյան հայկական եկեղեցի:',
        imagePath: 'assets/images/places/Kasagh_basilica.jpg',
        latitude: 40.5930,
        longitude: 44.3610,
        rating: 4.7,
      ),
    ],
  ),

  City(//Done
    id: 4,
    name: 'Թալին',
    region: 'Արագածոտն',
    description:
    'Պատմական քաղաք, որը հայտնի է միջնադարյան հայկական ճարտարապետությամբ:',
    imagePath: 'assets/images/regions/Talin.jpg',
    latitude: 40.3889,
    longitude: 43.8742,
    places: [
      Place(
        id: 12,
        name: 'Թալինի մայր տաճար',
        type: 'տաճար',
        description:
        'Մեծ 7-րդ դարի հայկական մայր տաճար:',
        imagePath: 'assets/images/places/Talin_cathedral.jpg',
        latitude: 40.3890,
        longitude: 43.8740,
        rating: 4.8,
      ),
      Place(
        id: 13,
        name: 'Արուճավանք',
        type: 'եկեղեցի',
        description:
        'Պատմական հայկական եկեղեցի Արուճ գյուղի մոտ:',
        imagePath: 'assets/images/places/Aruchavank.jpg',
        latitude: 40.3040, // VERIFY
        longitude: 44.1140,
        rating: 4.8,
      ),
    ],
  ),

  // ============================================================
  // ARARAT
  // ============================================================

  City(//Done
    id: 5,
    name: 'Արտաշատ',
    region: 'Արարատ',
    description:
    'Հնագույն քաղաք և Հայաստանի կարևոր պատմական կենտրոն:',
    imagePath: 'assets/images/regions/Artashat.jpg',
    latitude: 39.9566,
    longitude: 44.5469,
    places: [
      Place(
        id: 14,
        name: 'Դվինի հնագիտական վայր',
        type: 'հուշահամալիր',
        description:
        'Հնագույն հայկական մայրաքաղաք Դվինի հնագիտական մնացորդներ:',
        imagePath: 'assets/images/places/Dvin.jpg',
        latitude: 40.0100, // VERIFY
        longitude: 44.5750,
        rating: 4.7,
      ),
      Place(
        id: 15,
        name: 'Խոր Վիրապ',
        type: 'վանք',
        description:
        'Հայտնի վանք Արարատ լեռան հիանալի տեսարաններով:',
        imagePath: 'assets/images/places/Khor_virap.jpg',
        latitude: 39.8782,
        longitude: 44.5765,
        rating: 4.9,
      ),
    ],
  ),

  City(//Done
    id: 6,
    name: 'Մասիս',
    region: 'Արարատ',
    description:
    'Քաղաք Արարատյան դաշտում՝ Երևանի մոտ:',
    imagePath: 'assets/images/regions/Masis.jpg',
    latitude: 40.0640,
    longitude: 44.4170,
    places: [
      Place(
        id: 16,
        name: 'Արարատյան դաշտ',
        type: 'լեռ',
        description:
        'Լանդշաֆտ, որը առաջարկում է Արարատ լեռան հիանալի տեսարաններ:',
        imagePath: 'assets/images/places/Ararat_plain.jpg',
        latitude: 40.0700,
        longitude: 44.4300,
        rating: 4.7,
      ),
    ],
  ),

  City(//Done
    id: 7,
    name: 'Վեդի',
    region: 'Արարատ',
    description:
    'Քաղաք, որը շրջապատված է լեռներով և գյուղատնտեսական լանդշաֆտներով:',
    imagePath: 'assets/images/regions/Vedi.jpg',
    latitude: 39.9139,
    longitude: 44.7236,
    places: [
      Place(
        id: 17,
        name: 'Ուրծի լեռներ',
        type: 'լեռ',
        description:
        'Լեռնային լանդշաֆտներ Վեդիի մոտ:',
        imagePath: 'assets/images/places/Urts_mountain.jpg',
        latitude: 39.8800, // VERIFY
        longitude: 44.7500,
        rating: 4.6,
      ),
    ],
  ),

  // ============================================================
  // ARMAVIR
  // ============================================================

  City(//Done
    id: 8,
    name: 'Վաղարշապատ',
    region: 'Արմավիր',
    description:
    'Պատմական քաղաք և Հայաստանի ամենակարևոր կրոնական կենտրոններից մեկը:',
    imagePath: 'assets/images/regions/Vagharshapat.jpg',
    latitude: 40.1620,
    longitude: 44.2910,
    places: [
      Place(
        id: 18,
        name: 'Էջմիածնի մայր տաճար',
        type: 'տաճար',
        description:
        'Հայ Առաքելական Եկեղեցու հոգևոր կենտրոնը:',
        imagePath: 'assets/images/places/Echmiadzin_church.jpg',
        latitude: 40.1627,
        longitude: 44.2937,
        rating: 5.0,
      ),
      Place(
        id: 19,
        name: 'Սուրբ Գայանե եկեղեցի',
        type: 'եկեղեցի',
        description:
        '7-րդ դարի հայկական եկեղեցի Էջմիածնի մայր տաճարի մոտ:',
        imagePath: 'assets/images/places/Saint_Gayane_church.jpg',
        latitude: 40.1610,
        longitude: 44.2850,
        rating: 4.9,
      ),
      Place(
        id: 20,
        name: 'Սուրբ Հռիփսիմե եկեղեցի',
        type: 'եկեղեցի',
        description:
        'Հայաստանի ամենակարևոր վաղ միջնադարյան եկեղեցիներից մեկը:',
        imagePath: 'assets/images/places/Hripsime_church.jpg',
        latitude: 40.1666,
        longitude: 44.3040,
        rating: 4.9,
      ),
      Place(
        id: 21,
        name: 'Զվարթնոց մայր տաճար',
        type: 'տաճար',
        description:
        'Հիանալի 7-րդ դարի հայկական մայր տաճարի ավերակներ:',
        imagePath: 'assets/images/places/Zvartnots.jpg',
        latitude: 40.1561,
        longitude: 44.3517,
        rating: 4.9,
      ),
    ],
  ),

  City(//Done
    id: 9,
    name: 'Արմավիր',
    region: 'Արմավիր',
    description:
    'Կարևոր մարզային քաղաք Արարատյան դաշտի շրջակայքում:',
    imagePath: 'assets/images/regions/Armavir.jpg',
    latitude: 40.1540,
    longitude: 43.9870, // VERIFY
    places: [
      Place(
        id: 22,
        name: 'Արմավիրի պատմական վայրեր',
        type: 'հուշահամալիր',
        description:
        'Պատմական և հնագիտական վայրեր Արմավիրի շրջակայքում:',
        imagePath: 'assets/images/places/Armavir_history.jpg',
        latitude: 40.1470, // VERIFY
        longitude: 43.9800,
        rating: 4.5,
      ),
    ],
  ),

  City(//Done
    id: 10,
    name: 'Մեծամոր',
    region: 'Արմավիր',
    description:
    'Քաղաք, որը հայտնի է հնագույն Մեծամորի հնագիտական վայրով:',
    imagePath: 'assets/images/regions/Metsamor.jpg',
    latitude: 40.0728,
    longitude: 44.2917,
    places: [
      Place(
        id: 23,
        name: 'Մեծամորի պատմահնագիտական թանգարան',
        type: 'թանգարան',
        description:
        'Թանգարան, նվիրված հնագույն Մեծամորի հնագիտական վայրին:',
        imagePath: 'assets/images/places/Metsamor_museum.jpg',
        latitude: 40.1320, // VERIFY
        longitude: 44.1420,
        rating: 4.7,
      ),
    ],
  ),

  // ============================================================
  // GEGHARKUNIK
  // ============================================================

  City(//Done
    id: 11,
    name: 'Գավառ',
    region: 'Գեղարքունիք',
    description:
    'Գեղարքունիք մարզի վարչական կենտրոնը:',
    imagePath: 'assets/images/regions/Gavar.jpg',
    latitude: 40.3586,
    longitude: 45.1275,
    places: [
      Place(
        id: 24,
        name: 'Գավառի պատմական թանգարան',
        type: 'թանգարան',
        description:
        'Թանգարան, որը ներկայացնում է մարզի պատմությունն ու մշակույթը:',
        imagePath: 'assets/images/places/Gavar_museum.jpg',
        latitude: 40.3580,
        longitude: 45.1280,
        rating: 4.5,
      ),
    ],
  ),

  City(//Done
    id: 12,
    name: 'Սևան',
    region: 'Գեղարքունիք',
    description:
    'Քաղաք Սևանա լճի մոտ՝ Հայաստանի ամենահայտնի բնական հուշարձաններից մեկի կողքին:',
    imagePath: 'assets/images/regions/Sevan.jpg',
    latitude: 40.5486,
    longitude: 44.9519,
    places: [
      Place(
        id: 25,
        name: 'Սևանա լիճ',
        type: 'լիճ',
        description:
        'Հայաստանի ամենամեծ լիճը և աշխարհի ամենամեծ բարձրադիր քաղցրահամ լճերից մեկը:',
        imagePath: 'assets/images/places/Sevan_lake.jpg',
        latitude: 40.5600,
        longitude: 45.0000,
        rating: 5.0,
      ),
      Place(
        id: 26,
        name: 'Սևանավանք',
        type: 'վանք',
        description:
        'Պատմական վանք Սևանի թերակղզում:',
        imagePath: 'assets/images/places/Sevanavank.jpg',
        latitude: 40.5650,
        longitude: 44.9980,
        rating: 4.9,
      ),
      Place(
        id: 27,
        name: 'Սևանի թերակղզի',
        type: '',
        description:
        'Գեղատեսիլ թերակղզի՝ Սևանա լճի հիանալի տեսարաններով:',
        imagePath: 'assets/images/places/Sevan_peninsula.jpg',
        latitude: 40.5600,
        longitude: 44.9930,
        rating: 4.8,
      ),
    ],
  ),

  City(//Done
    id: 13,
    name: 'Մարտունի',
    region: 'Գեղարքունիք',
    description:
    'Քաղաք Սևանա լճի հարավային կողմում:',
    imagePath: 'assets/images/regions/Martuni.jpg',
    latitude: 40.1325,
    longitude: 45.3035,
    places: [
      Place(
        id: 28,
        name: 'Սևանա լճի հարավային ափ',
        type: 'լիճ',
        description:
        'Գեղեցիկ լանդշաֆտներ և տեսարաններ Սևանա լճի հարավային ափով:',
        imagePath: 'assets/images/places/Sevan_south.jpg',
        latitude: 40.1500, // VERIFY
        longitude: 45.2600,
        rating: 4.7,
      ),
    ],
  ),

  City(//Done
    id: 14,
    name: 'Վարդենիս',
    region: 'Գեղարքունիք',
    description:
    'Քաղաք հարավ-արևելյան Գեղարքունիքում՝ լեռներով շրջապատված:',
    imagePath: 'assets/images/regions/Vardenis.jpg',
    latitude: 40.1830,
    longitude: 45.7310,
    places: [
      Place(
        id: 29,
        name: 'Վարդենյաց լեռնանցք',
        type: 'լեռ',
        description:
        'Հիանալի լեռնանցք, որը կապում է Գեղարքունիքը և Վայոց Ձորը:',
        imagePath: 'assets/images/places/Vardenyats_pass.jpg',
        latitude: 39.9900, // VERIFY
        longitude: 45.6000,
        rating: 4.8,
      ),
    ],
  ),

  // ============================================================
  // KOTAYK
  // ============================================================

  City(//Done
    id: 15,
    name: 'Հրազդան',
    region: 'Կոտայք',
    description:
    'Կոտայք մարզի վարչական կենտրոնը:',
    imagePath: 'assets/images/regions/Hrazdan.jpg',
    latitude: 40.4989,
    longitude: 44.7667,
    places: [
      Place(
        id: 30,
        name: 'Հրազդանի կիրճ',
        type: 'կիրճ',
        description:
        'Գեղատեսիլ կիրճ՝ լեռներով և անտառներով շրջապատված:',
        imagePath: 'assets/images/places/Hrazdan_gorge.jpg',
        latitude: 40.4900,
        longitude: 44.7600,
        rating: 4.7,
      ),
      Place(
        id: 31,
        name: 'Ախթալայի ջրամբար',
        type: 'գետ',
        description:
        'Գեղատեսիլ ջրամբար՝ բնական լանդշաֆտներով շրջապատված:',
        imagePath: 'assets/images/places/Akhtala_reservoir.jpg',
        latitude: 40.5200, // VERIFY
        longitude: 44.7800,
        rating: 4.5,
      ),
    ],
  ),

  City(//Done
    id: 16,
    name: 'Աբովյան',
    region: 'Կոտայք',
    description:
    'Մեծ քաղաք Երևանի հյուսիս-արևելքում:',
    imagePath: 'assets/images/regions/Abovyan.jpg',
    latitude: 40.2734,
    longitude: 44.6250,
    places: [
      Place(
        id: 32,
        name: 'Աբովյանի մշակութային կենտրոն',
        type: 'թանգարան',
        description:
        'Մշակութային վայր Աբովյան քաղաքում:',
        imagePath: 'assets/images/places/Abovyan_church.jpg',
        latitude: 40.2700,
        longitude: 44.6300,
        rating: 4.4,
      ),
    ],
  ),

  City(//Done
    id: 17,
    name: 'Ծաղկաձոր',
    region: 'Կոտայք',
    description:
    'Հայտնի լեռնային կուրորտ՝ սկի, անտառներ և վանքեր:',
    imagePath: 'assets/images/regions/Tsaghkadzor.jpg',
    latitude: 40.5319,
    longitude: 44.7214,
    places: [
      Place(
        id: 33,
        name: 'Կեչառիսի վանք',
        type: 'վանք',
        description:
        'Միջնադարյան վանական համալիր Ցաղկաձորի կենտրոնում:',
        imagePath: 'assets/images/places/Kecharis.jpg',
        latitude: 40.5340,
        longitude: 44.7200,
        rating: 4.9,
      ),
      Place(
        id: 34,
        name: 'Ծաղկաձորի լեռնապարկուր',
        type: 'լեռ',
        description:
        'Լեռնապարկուր, որը առաջարկում է շրջակայքի պանորամային տեսարաններ:',
        imagePath: 'assets/images/places/Tsaghkadzor_ropeway.jpg',
        latitude: 40.5300, // VERIFY
        longitude: 44.7100,
        rating: 4.8,
      ),
      Place(
        id: 35,
        name: 'Ծաղկաձորի կուրորտ',
        type: 'լեռ',
        description:
        'Հայտնի լեռնային ուղղություն՝ ձմեռային և ամառային զբոսաշրջության համար:',
        imagePath: 'assets/images/places/Tsaghkadzor_resort.jpg',
        latitude: 40.5330,
        longitude: 44.7200,
        rating: 4.8,
      ),
    ],
  ),

  City(//Done
    id: 18,
    name: 'Չարենցավան',
    region: 'Կոտայք',
    description:
    'Քաղաք՝ լեռնային լանդշաֆտներով և գետային կիրճերով շրջապատված:',
    imagePath: 'assets/images/regions/Charentsavan.jpg',
    latitude: 40.4000,
    longitude: 44.6400,
    places: [
      Place(
        id: 36,
        name: 'Հրազդանի կիրճ',
        type: 'կիրճ',
        description:
        'Բնական կիրճ՝ գեղատեսիլ լանդշաֆտներով քաղաքի մոտ:',
        imagePath: 'assets/images/places/Charentsavan_gorge.jpg',
        latitude: 40.4000,
        longitude: 44.6300,
        rating: 4.6,
      ),
    ],
  ),

  // ============================================================
  // LORI
  // ============================================================

  City(//Done
    id: 19,
    name: 'Վանաձոր',
    region: 'Լոռի',
    description:
    'Լոռի մարզի ամենամեծ քաղաքը՝ լեռներով և անտառներով շրջապատված:',
    imagePath: 'assets/images/regions/Vanadzor.jpg',
    latitude: 40.8128,
    longitude: 44.4883,
    places: [
      Place(
        id: 37,
        name: 'Վանաձորի կենտրոնական պարկ',
        type: 'լեռ',
        description:
        'Հայտնի հանգստի գոտի Վանաձորի կենտրոնում:',
        imagePath: 'assets/images/places/Vanadzor_park.jpg',
        latitude: 40.8130,
        longitude: 44.4900,
        rating: 4.6,
      ),
      Place(
        id: 38,
        name: 'Վանաձորի թանգարան',
        type: 'թանգարան',
        description:
        'Թանգարան, որը ներկայացնում է Լոռու պատմությունն ու մշակույթը:',
        imagePath: 'assets/images/places/Vanadzor_museum.jpg',
        latitude: 40.8130,
        longitude: 44.4880,
        rating: 4.5,
      ),
    ],
  ),

  City(//Done
    id: 20,
    name: 'Ալավերդի',
    region: 'Լոռի',
    description:
    'Քաղաք հիանալի Դեբեդի կիրճում:',
    imagePath: 'assets/images/regions/Alaverdi.jpg',
    latitude: 41.0978,
    longitude: 44.6612,
    places: [
      Place(
        id: 39,
        name: 'Սանահինի վանք',
        type: 'վանք',
        description:
        'ՅՈՒՆԵՍԿՕ-ի Համաշխարհային ժառանգության միջնադարյան վանական համալիր:',
        imagePath: 'assets/images/places/Sanahin.jpg',
        latitude: 41.0883,
        longitude: 44.6640,
        rating: 4.9,
      ),
      Place(
        id: 40,
        name: 'Հաղպատի վանք',
        type: 'վանք',
        description:
        'ՅՈՒՆԵՍԿՕ-ի Համաշխարհային ժառանգության վանական համալիր՝ Դեբեդի կիրճի վերևում:',
        imagePath: 'assets/images/places/Haghpat.jpg',
        latitude: 41.0937,
        longitude: 44.7108,
        rating: 4.9,
      ),
      Place(
        id: 41,
        name: 'Դեբեդի կիրճ',
        type: 'կիրճ',
        description:
        'Հյուսիսային Հայաստանի ամենահիանալի բնական լանդշաֆտներից մեկը:',
        imagePath: 'assets/images/places/Debed_canyon.jpg',
        latitude: 41.1000,
        longitude: 44.6700,
        rating: 4.9,
      ),
    ],
  ),

  City(//Done
    id: 21,
    name: 'Ստեփանավան',
    region: 'Լոռի',
    description:
    'Կանաչ լեռնային քաղաք, որը հայտնի է իր անտառներով և դենդրոպարկով:',
    imagePath: 'assets/images/regions/Stepanavan.jpg',
    latitude: 41.0089,
    longitude: 44.3858,
    places: [
      Place(
        id: 42,
        name: 'Ստեփանավանի դենդրոպարկ',
        type: 'լեռ',
        description:
        'Հայտնի բուսաբանական պարկ՝ բազմազան ծառերով և բույսերով:',
        imagePath: 'assets/images/places/Dendropark.jpg',
        latitude: 41.0100,
        longitude: 44.3900,
        rating: 4.8,
      ),
      Place(
        id: 43,
        name: 'Լոռու ամրոց',
        type: 'ամրոց',
        description:
        'Կարևոր միջնադարյան հայկական ամրոցի ավերակներ:',
        imagePath: 'assets/images/places/Lori_fortress.jpg',
        latitude: 41.0030, // VERIFY
        longitude: 44.4430,
        rating: 4.8,
      ),
    ],
  ),

  City(//Done
    id: 22,
    name: 'Սպիտակ',
    region: 'Լոռի',
    description:
    'Հյուսիսային հայկական քաղաք՝ լեռնային լանդշաֆտներով շրջապատված:',
    imagePath: 'assets/images/regions/Spitak.jpg',
    latitude: 40.8333,
    longitude: 44.2667,
    places: [
      Place(
        id: 44,
        name: 'Սպիտակի բնական լանդշաֆտներ',
        type: 'լեռ',
        description:
        'Լեռնային լանդշաֆտներ քաղաքի շրջակայքում:',
        imagePath: 'assets/images/places/Spitak_landscape.jpg',
        latitude: 40.8300,
        longitude: 44.2700,
        rating: 4.5,
      ),
    ],
  ),

  // ============================================================
  // SHIRAK
  // ============================================================

  City(//Done
    id: 23,
    name: 'Գյումրի',
    region: 'Շիրակ',
    description:
    'Հայաստանի երկրորդ ամենամեծ քաղաքը, հայտնի է իր ճարտարապետությամբ, արվեստով և մշակութային ժառանգությամբ:',
    imagePath: 'assets/images/regions/Gyumri.jpg',
    latitude: 40.7961,
    longitude: 43.8458,
    places: [
      Place(
        id: 45,
        name: 'Կումայրիի պատմական թաղամաս',
        type: 'հուշահամալիր',
        description:
        'Պատմական փողոցներ և շենքեր՝ Գյումրու ճարտարապետական ժառանգությունը ներկայացնող:',
        imagePath: 'assets/images/places/Kumayri.jpg',
        latitude: 40.7896,
        longitude: 43.8476,
        rating: 4.9,
      ),
      Place(
        id: 46,
        name: 'Սև ամրոց',
        type: 'ամրոց',
        description:
        'Պատմական ռազմական ամրոց Գյումրիում:',
        imagePath: 'assets/images/places/Black_fortress.jpg',
        latitude: 40.7845, // VERIFY
        longitude: 43.8248,
        rating: 4.8,
      ),
      Place(
        id: 47,
        name: 'Մայր Հայաստան',
        type: 'հուշահամալիր',
        description:
        'Հուշարձան Գյումրու վերևում:',
        imagePath: 'assets/images/places/Mother_armenia_gyumri.jpg',
        latitude: 40.7808, // VERIFY
        longitude: 43.8246,
        rating: 4.7,
      ),
      Place(
        id: 48,
        name: 'Ասլամազյան քույրերի պատկերասրահ',
        type: 'թանգարան',
        description:
        'Արվեստի պատկերասրահ, նվիրված Ասլամազյան քույրերի ստեղծագործություններին:',
        imagePath: 'assets/images/places/Aslamazyan_gallery.jpg',
        latitude: 40.7865,
        longitude: 43.8408,
        rating: 4.8,
      ),
      Place(
        id: 49,
        name: 'Յոթ Վերք եկեղեցի',
        type: 'եկեղեցի',
        description:
        'Պատմական եկեղեցի կենտրոնական Գյումրիում:',
        imagePath: 'assets/images/places/Seven_wounds.jpg',
        latitude: 40.7863,
        longitude: 43.8423,
        rating: 4.8,
      ),
    ],
  ),

  City(//Done
    id: 24,
    name: 'Արթիկ',
    region: 'Շիրակ',
    description:
    'Պատմական քաղաք, որը հայտնի է եկեղեցիներով և հրաբխային քարի ճարտարապետությամբ:',
    imagePath: 'assets/images/regions/Artik.jpg',
    latitude: 40.6167,
    longitude: 43.9667,
    places: [
      Place(
        id: 50,
        name: 'Հառիճավանք',
        type: 'վանք',
        description:
        'Պատմական հայկական վանք Արթիկի մոտ:',
        imagePath: 'assets/images/places/Artik.jpg',
        latitude: 40.6100, // VERIFY
        longitude: 43.9780,
        rating: 4.8,
      ),
    ],
  ),

  City(//Done
    id: 25,
    name: 'Մարալիկ',
    region: 'Շիրակ',
    description:
    'Քաղաք Շիրակ մարզի հարավային մասում:',
    imagePath: 'assets/images/regions/Maralik.jpg',
    latitude: 40.5667,
    longitude: 43.8667,
    places: [
      Place(
        id: 51,
        name: 'Մարալիկի եկեղեցի',
        type: 'եկեղեցի',
        description:
        'Պատմական հայկական եկեղեցի մարզում:',
        imagePath: 'assets/images/places/Maralik_church.jpg',
        latitude: 40.5700,
        longitude: 43.8700,
        rating: 4.5,
      ),
    ],
  ),

  // ============================================================
  // SYUNIK
  // ============================================================

  City(//Done
    id: 26,
    name: 'Կապան',
    region: 'Սյունիք',
    description:
    'Սյունիք մարզի ամենամեծ քաղաքը՝ լեռներով շրջապատված:',
    imagePath: 'assets/images/regions/Syunik.jpg',
    latitude: 39.2074,
    longitude: 46.4058,
    places: [
      Place(
        id: 52,
        name: 'Վահանավանք',
        type: 'վանք',
        description:
        'Միջնադարյան վանք Կապանի մոտ:',
        imagePath: 'assets/images/places/Vahanavank.jpg',
        latitude: 39.1500, // VERIFY
        longitude: 46.3200,
        rating: 4.8,
      ),
      Place(
        id: 53,
        name: 'Հալիձորի ամրոց',
        type: 'ամրոց',
        description:
        'Պատմական ամրոց՝ շրջակա լեռների վերևում:',
        imagePath: 'assets/images/places/Halidzor.jpg',
        latitude: 39.3860, // VERIFY
        longitude: 46.3280,
        rating: 4.8,
      ),
      Place(
        id: 54,
        name: 'Խուստուփ լեռ',
        type: 'լեռ',
        description:
        'Պատմական լեռ հարավային Սյունիք մարզում:',
        imagePath: 'assets/images/places/Khustup.jpg',
        latitude: 39.1250, // VERIFY
        longitude: 46.3250,
        rating: 4.9,
      ),
    ],
  ),

  City(//Done
    id: 27,
    name: 'Գորիս',
    region: 'Սյունիք',
    description:
    'Պատմական քաղաք, որը հայտնի է իր անսովոր ժայռոտ ձևավորումներով և մոտակա գրավչություններով:',
    imagePath: 'assets/images/regions/Goris.jpg',
    latitude: 39.5111,
    longitude: 46.3380,
    places: [
      Place(
        id: 55,
        name: 'Հին Գորիս',
        type: 'բնական',
        description:
        'Գորիսի պատմական մասը՝ առանձնահատուկ ժայռոտ ձևավորումներով շրջապատված:',
        imagePath: 'assets/images/places/Old_Goris.jpg',
        latitude: 39.5100,
        longitude: 46.3400,
        rating: 4.9,
      ),
      Place(
        id: 56,
        name: 'Խնձորեսկ',
        type: 'բնական',
        description:
        'Պատմական քարայրային բնակավայր՝ դրամատիկ ժայռոտ ձևավորումներով շրջապատված:',
        imagePath: 'assets/images/places/Khndzoresk.jpg',
        latitude: 39.5150, // VERIFY
        longitude: 46.4200,
        rating: 4.9,
      ),
      Place(
        id: 57,
        name: 'Տաթևի վանք',
        type: 'վանք',
        description:
        'Հայաստանի ամենահայտնի միջնադարյան վանքերից մեկը:',
        imagePath: 'assets/images/places/Tatev.jpg',
        latitude: 39.3801,
        longitude: 46.2495,
        rating: 5.0,
      ),
      Place(
        id: 58,
        name: 'Տաթևի թևեր',
        type: 'թանգարան',
        description:
        'Հայտնի օդային լարային ճանապարհ, որը կապում է Հալիձորը Տաթևի հետ:',
        imagePath: 'assets/images/places/Wings_of_tatev.jpg',
        latitude: 39.3850, // VERIFY
        longitude: 46.2700,
        rating: 4.9,
      ),
    ],
  ),

  City(//Done
    id: 28,
    name: 'Սիսիան',
    region: 'Սյունիք',
    description:
    'Քաղաք՝ լեռներով և կարևոր հնագիտական վայրերով շրջապատված:',
    imagePath: 'assets/images/regions/Sisian.jpg',
    latitude: 39.5186,
    longitude: 46.0300,
    places: [
      Place(
        id: 59,
        name: 'Քարահունջ',
        type: 'բնական',
        description:
        'Հնագույն հնագիտական հուշարձան, որը հաճախ անվանում են հայկական Սթոունհենջ:',
        imagePath: 'assets/images/places/Karahunj.jpg',
        latitude: 39.5500,
        longitude: 46.0200,
        rating: 4.8,
      ),
      Place(
        id: 60,
        name: 'Շաքիի ջրվեժ',
        type: 'գետ',
        description:
        'Գեղեցիկ ջրվեժ Սիսիանի մոտ:',
        imagePath: 'assets/images/places/Shaqi.jpg',
        latitude: 39.5500, // VERIFY
        longitude: 45.9900,
        rating: 4.8,
      ),
    ],
  ),

  City(//Done
    id: 29,
    name: 'Մեղրի',
    region: 'Սյունիք',
    description:
    'Հայաստանի ամենահարավային քաղաքը, հայտնի է իր տաք կլիմայով և պատմական ճարտարապետությամբ:',
    imagePath: 'assets/images/regions/Meghri.jpg',
    latitude: 38.9018,
    longitude: 46.2457,
    places: [
      Place(
        id: 61,
        name: 'Մեղրիի ամրոց',
        type: 'ամրոց',
        description:
        'Պատմական ամրոց՝ քաղաքի և շրջակա լեռների վերևում:',
        imagePath: 'assets/images/places/Meghri_fortress.jpg',
        latitude: 38.9040,
        longitude: 46.2480,
        rating: 4.7,
      ),
    ],
  ),

  // ============================================================
  // VAYOTS DZOR
  // ============================================================

  City(//Done
    id: 30,
    name: 'Եղեգնաձոր',
    region: 'Վայոց Ձոր',
    description:
    'Վայոց Ձոր մարզի վարչական կենտրոնը:',
    imagePath: 'assets/images/regions/Yeghegnadzor.jpg',
    latitude: 39.7608,
    longitude: 45.3333,
    places: [
      Place(
        id: 62,
        name: 'Նորավանք',
        type: 'վանք',
        description:
        'Հիանալի միջնադարյան վանք՝ կարմիր ժայռերով շրջապատված:',
        imagePath: 'assets/images/places/Noravank.jpg',
        latitude: 39.6840,
        longitude: 45.2330,
        rating: 4.9,
      ),
      Place(
        id: 63,
        name: 'Արենիի քարայր',
        type: 'բնական',
        description:
        'Կարևոր հնագիտական քարայրային վայր՝ նախապատմական հայտնագործություններով հայտնի:',
        imagePath: 'assets/images/places/Areni_cave.jpg',
        latitude: 39.7360, // VERIFY
        longitude: 45.2000,
        rating: 4.8,
      ),
    ],
  ),

  City(//Done
    id: 31,
    name: 'Ջերմուկ',
    region: 'Վայոց Ձոր',
    description:
    'Հայտնի լեռնային կուրորտ՝ հանքային ջրերով և բնական լանդշաֆտներով հայտնի:',
    imagePath: 'assets/images/regions/Jermuk.jpg',
    latitude: 39.8408,
    longitude: 45.6716,
    places: [
      Place(
        id: 64,
        name: 'Ջերմուկի ջրվեժ',
        type: 'գետ',
        description:
        'Գեղեցիկ ջրվեժ կուրորտային քաղաքում:',
        imagePath: 'assets/images/places/Jermuk.jpg',
        latitude: 39.8438,
        longitude: 45.6786,
        rating: 4.9,
      ),
      Place(
        id: 65,
        name: 'Հանքային ջրերի պատկերասրահ',
        type: 'թանգարան',
        description:
        'Հայտնի վայր, որտեղ այցելուները կարող են ըմպել Ջերմուկի հանքային ջուր:',
        imagePath: 'assets/images/places/Jermuk_gallery.jpg',
        latitude: 39.8420,
        longitude: 45.6700,
        rating: 4.7,
      ),
    ],
  ),

  City(//Done
    id: 32,
    name: 'Վայք',
    region: 'Վայոց Ձոր',
    description:
    'Լեռնային քաղաք՝ Վայոց Ձորի լանդշաֆտներով շրջապատված:',
    imagePath: 'assets/images/regions/Vayq.jpg',
    latitude: 39.6877,
    longitude: 45.4604,
    places: [
      Place(
        id: 66,
        name: 'Վայոց Ձորի լեռներ',
        type: 'լեռ',
        description:
        'Լեռնային լանդշաֆտներ Վայքի շրջակայքում:',
        imagePath: 'assets/images/places/Vayots_dzor_mountains.jpg',
        latitude: 39.6900,
        longitude: 45.4700,
        rating: 4.6,
      ),
    ],
  ),

  // ============================================================
  // TAVUSH
  // ============================================================

  City(//Done
    id: 33,
    name: 'Իջևան',
    region: 'Տավուշ',
    description:
    'Տավուշ մարզի վարչական կենտրոնը՝ անտառներով և լեռներով շրջապատված:',
    imagePath: 'assets/images/regions/Ijevan.jpg',
    latitude: 40.8780,
    longitude: 45.1490,
    places: [
      Place(
        id: 67,
        name: 'Իջևանի դենդրոպարկ',
        type: 'լեռ',
        description:
        'Բուսաբանական պարկ՝ բազմազան ծառերով և բնական լանդշաֆտներով:',
        imagePath: 'assets/images/places/Ijevan_dendropark.jpg',
        latitude: 40.8800,
        longitude: 45.1500,
        rating: 4.7,
      ),
      Place(
        id: 68,
        name: 'Լաստիվեր',
        type: 'անտառ',
        description:
        'Գեղատեսիլ բնական գոտի՝ անտառներով, քարայրերով և ջրվեժներով հայտնի:',
        imagePath: 'assets/images/places/Lastiver.jpg',
        latitude: 40.8700, // VERIFY
        longitude: 45.2500,
        rating: 4.9,
      ),
    ],
  ),

  City(//Done
    id: 34,
    name: 'Դիլիջան',
    region: 'Տավուշ',
    description:
    'Հայտնի լեռնային կուրորտ՝ անտառներով շրջապատված:',
    imagePath: 'assets/images/regions/Dilijan.jpg',
    latitude: 40.7405,
    longitude: 44.8641,
    places: [
      Place(
        id: 69,
        name: 'Հին Դիլիջան',
        type: 'լեռ',
        description:
        'Պատմական թաղամաս՝ ավանդական հայկական ճարտարապետությամբ:',
        imagePath: 'assets/images/places/Old_dilijan.jpg',
        latitude: 40.7410,
        longitude: 44.8660,
        rating: 4.9,
      ),
      Place(
        id: 70,
        name: 'Պարզ լիճ',
        type: 'լիճ',
        description:
        'Գեղեցիկ լիճ՝ Դիլիջանի անտառներով շրջապատված:',
        imagePath: 'assets/images/places/Parz_lake.jpg',
        latitude: 40.7750,
        longitude: 44.9390,
        rating: 4.9,
      ),
      Place(
        id: 71,
        name: 'Հաղարծինի վանք',
        type: 'վանք',
        description:
        'Միջնադարյան վանական համալիր՝ Դիլիջանի անտառներում թաքնված:',
        imagePath: 'assets/images/places/Haghartsin.jpg',
        latitude: 40.7855,
        longitude: 44.9892,
        rating: 4.9,
      ),
    ],
  ),

  City(//Done
    id: 35,
    name: 'Բերդ',
    region: 'Տավուշ',
    description:
    'Քաղաք՝ Տավուշի լեռներով և անտառներով շրջապատված:',
    imagePath: 'assets/images/regions/Berd.jpg',
    latitude: 40.8786,
    longitude: 45.3917,
    places: [
      Place(
        id: 72,
        name: 'Տավուշի ամրոց',
        type: 'ամրոց',
        description:
        'Միջնադարյան ամրոց լեռներում՝ Բերդի մոտ:',
        imagePath: 'assets/images/regions/Tavush_fortress.jpg',
        latitude: 40.8780,
        longitude: 45.3930,
        rating: 4.7,
      ),
    ],
  ),

  City(//Done
    id: 36,
    name: 'Նոյեմբերյան',
    region: 'Տավուշ',
    description:
    'Քաղաք հյուսիսային Տավուշում՝ անտառների և լեռների մոտ:',
    imagePath: 'assets/images/regions/Noyemberyan.jpg',
    latitude: 41.1722,
    longitude: 44.9957,
    places: [
      Place(
        id: 73,
        name: 'Տավուշի անտառներ',
        type: 'լեռ',
        description:
        'Կանաչ անտառային լանդշաֆտներ հյուսիսային Տավուշի շրջակայքում:',
        imagePath: 'assets/images/places/Tavush_forests.jpg',
        latitude: 41.1700,
        longitude: 44.9900,
        rating: 4.6,
      ),
    ],
  ),
];

final List<Place> places = [
  for (final city in cities)
    for (final place in city.places)
      Place(
        id: place.id,
        name: place.name,
        type: place.type,
        description: place.description,
        imagePath: place.imagePath,
        latitude: place.latitude,
        longitude: place.longitude,
        rating: place.rating,
        city: place.city.isNotEmpty ? place.city : city.name,
      ),
];