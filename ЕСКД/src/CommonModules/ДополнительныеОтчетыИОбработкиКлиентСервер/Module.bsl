///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Имена видов объектов.

// Печатная форма.
//
// Возвращаемое значение:
//   Строка - имя вида дополнительных печатных форм.
//
Функция ВидОбработкиПечатнаяФорма() Экспорт
	
	Возврат "ПечатнаяФорма"; // Внутренний идентификатор.
	
КонецФункции

// Заполнение объекта.
//
// Возвращаемое значение:
//   Строка - имя вида дополнительных обработок заполнения.
//
Функция ВидОбработкиЗаполнениеОбъекта() Экспорт
	
	Возврат "ЗаполнениеОбъекта"; // Внутренний идентификатор.
	
КонецФункции

// Создание связанных объектов.
//
// Возвращаемое значение:
//   Строка - имя вида дополнительных обработок создания связанных объектов.
//
Функция ВидОбработкиСозданиеСвязанныхОбъектов() Экспорт
	
	Возврат "СозданиеСвязанныхОбъектов"; // Внутренний идентификатор.
	
КонецФункции

// Назначаемый отчет.
//
// Возвращаемое значение:
//   Строка - имя вида дополнительных контекстных отчетов.
//
Функция ВидОбработкиОтчет() Экспорт
	
	Возврат "Отчет"; // Внутренний идентификатор.
	
КонецФункции

// Создание связанных объектов.
//
// Возвращаемое значение:
//   Строка - имя вида дополнительных контекстных отчетов.
//
Функция ВидОбработкиШаблонСообщения() Экспорт
	
	Возврат "ШаблонСообщения"; // Внутренний идентификатор.
	
КонецФункции

// Дополнительная обработка.
//
// Возвращаемое значение:
//   Строка - имя вида дополнительных глобальных обработок.
//
Функция ВидОбработкиДополнительнаяОбработка() Экспорт
	
	Возврат "ДополнительнаяОбработка"; // Внутренний идентификатор.
	
КонецФункции

// Дополнительный отчет.
//
// Возвращаемое значение:
//   Строка - имя вида дополнительных глобальных отчетов.
//
Функция ВидОбработкиДополнительныйОтчет() Экспорт
	
	Возврат "ДополнительныйОтчет"; // Внутренний идентификатор.
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Имена типов команд.

// Возвращает имя типа команд с вызовом серверного метода. Для выполнения команд такого типа
//   в модуле объекта следует определить экспортную процедуру по следующему шаблону.
//   
//   Для глобальных отчетов и обработок (Вид = "ДополнительнаяОбработка" или Вид = "ДополнительныйОтчет"):
//       // Обработчик серверных команд.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка    - имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ПараметрыВыполнения  - Структура - контекст выполнения команды.
//       //       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - ссылка обработки.
//       //           Может использоваться для чтения параметров обработки.
//       //           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//       //       * РезультатВыполнения - Структура - результат выполнения команды.
//       //           Может использоваться для передачи результата с сервера или из фонового задания в исходную точку.
//       //           В частности, возвращается функциями ДополнительныеОтчетыИОбработки.ВыполнитьКоманду()
//       //           и ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(),
//       //           а также может быть получено из временного хранилища
//       //           в обработчике ожидания процедуры ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне().
//       //
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыВыполнения) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для печатных форм (Вид = "ПечатнаяФорма"):
//       // Обработчик печати.
//       //
//       // Параметры:
//       //   МассивОбъектов - Массив - ссылки на объекты, которые нужно распечатать.
//       //   КоллекцияПечатныхФорм - ТаблицаЗначений - информация о табличных документах.
//       //       Используется для передачи в параметрах функции УправлениеПечатью.СведенияОПечатнойФорме().
//       //   ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах.
//       //       Используется для передачи в параметрах процедуры УправлениеПечатью.ЗадатьОбластьПечатиДокумента().
//       //   ПараметрыВывода - Структура - дополнительные параметры сформированных табличных документов.
//       //       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - ссылка обработки.
//       //           Может использоваться для чтения параметров обработки.
//       //           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//       //
//       // Пример:
//       //  	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "<ИдентификаторПечатнойФормы>");
//       //  	Если ПечатнаяФорма <> Неопределено Тогда
//       //  		ТабличныйДокумент = Новый ТабличныйДокумент;
//       //  		ТабличныйДокумент.КлючПараметровПечати = "<КлючСохраненияПараметровПечатнойФормы>";
//       //  		Для Каждого Ссылка Из МассивОбъектов Цикл
//       //  			Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
//       //  				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
//       //  			КонецЕсли;
//       //  			НачалоОбласти = ТабличныйДокумент.ВысотаТаблицы + 1;
//       //  			// ... код по формированию табличного документа ...
//       //  			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НачалоОбласти, ОбъектыПечати, Ссылка);
//       //  		КонецЦикла;
//       //  		ПечатнаяФорма.ТабличныйДокумент = ТабличныйДокумент;
//       //  	КонецЕсли;
//       //
//       Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для обработок создания связанных объектов (Вид = "СозданиеСвязанныхОбъектов"):
//       // Обработчик серверных команд.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ОбъектыНазначения    - Массив - ссылки объектов, для которых вызвана команда.
//       //   СозданныеОбъекты     - Массив - ссылки новых объектов, созданных в результате выполнения команды.
//       //   ПараметрыВыполнения  - Структура - контекст выполнения команды.
//       //       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - ссылка обработки.
//       //           Может использоваться для чтения параметров обработки.
//       //           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//       //       * РезультатВыполнения - Структура - результат выполнения команды.
//       //           Может использоваться для передачи результата с сервера или из фонового задания в исходную точку.
//       //           В частности, возвращается функциями ДополнительныеОтчетыИОбработки.ВыполнитьКоманду()
//       //           и ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(),
//       //           а также может быть получено из временного хранилища
//       //           в обработчике ожидания процедуры ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне().
//       //
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения, СозданныеОбъекты, ПараметрыВыполнения) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для обработок заполнения (Вид = "ЗаполнениеОбъекта"):
//       // Обработчик серверных команд.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ОбъектыНазначения    - Массив - ссылки объектов, для которых вызвана команда.
//       //       - Неопределено - для команд "ЗаполнениеФормы".
//       //   ПараметрыВыполнения  - Структура - контекст выполнения команды.
//       //       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - ссылка обработки.
//       //           Может использоваться для чтения параметров обработки.
//       //           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//       //       * РезультатВыполнения - Структура - результат выполнения команды.
//       //           Может использоваться для передачи результата с сервера или из фонового задания в исходную точку.
//       //           В частности, возвращается функциями ДополнительныеОтчетыИОбработки.ВыполнитьКоманду()
//       //           и ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(),
//       //           а также может быть получено из временного хранилища
//       //           в обработчике ожидания процедуры ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне().
//       //
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения, ПараметрыВыполнения) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//
// Возвращаемое значение:
//   Строка - имя типа команд с вызовом серверного метода.
//
Функция ТипКомандыВызовСерверногоМетода() Экспорт
	
	Возврат "ВызовСерверногоМетода"; // Внутренний идентификатор.
	
КонецФункции

// Возвращает имя типа команд с вызовом клиентского метода. Для выполнения команд такого типа
//   в основной форме внешнего объекта следует определить клиентскую экспортную процедуру по следующему шаблону.
//   
//   Для глобальных отчетов и обработок (Вид = "ДополнительнаяОбработка" или Вид = "ДополнительныйОтчет"):
//       &НаКлиенте
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для печатных форм (Вид = "ПечатнаяФорма"):
//       &НаКлиенте
//       Процедура Печать(ИдентификаторКоманды, ОбъектыНазначенияМассив) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для обработок создания связанных объектов (Вид = "СозданиеСвязанныхОбъектов"):
//       &НаКлиенте
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначенияМассив, СозданныеОбъекты) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для обработок заполнения и контекстных отчетов (Вид = "ЗаполнениеОбъекта" или Вид = "Отчет"):
//       &НаКлиенте
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначенияМассив) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Дополнительно (для всех видов) в параметре формы "ДополнительнаяОбработкаСсылка" передается ссылка этого объекта
//     (элемент справочника ДополнительныеОтчетыИОбработки, соответствующий этому объекту),
//     которая может использоваться для фонового выполнения длительных операций.
//     Подробнее см. в документации к подсистеме, раздел "Фоновое выполнение длительных операций".
//
// Возвращаемое значение:
//   Строка - имя типа команд с вызовом клиентского метода.
//
Функция ТипКомандыВызовКлиентскогоМетода() Экспорт
	
	Возврат "ВызовКлиентскогоМетода"; // Внутренний идентификатор.
	
КонецФункции

// Возвращает имя типа команд по открытию формы. При выполнении этих команд
// открывается основная форма внешнего объекта с указанными ниже параметрами.
//
//   Общие параметры:
//       ИдентификаторКоманды - Строка - имя команды, определенное в функции СведенияОВнешнейОбработке().
//       ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - ссылка этого объекта.
//           Может использоваться для чтения и сохранения параметров обработки.
//           Также может использоваться для фонового выполнения длительных операций.
//           Подробнее см. в документации к подсистеме, раздел "Фоновое выполнение длительных операций".
//       ИмяФормы - Строка - имя формы-владельца, из которой вызвана эта команда.
//   
//   Вспомогательные параметры для обработок создания связанных объектов (Вид = "СозданиеСвязанныхОбъектов"),
//   обработок заполнения (Вид = "ЗаполнениеОбъекта") и контекстных отчетов (Вид = "Отчет"):
//       ОбъектыНазначения - Массив - Ссылки объектов, для которых вызвана команда.
//   
//   Пример чтения общих параметров:
//       ОбъектСсылка = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ДополнительнаяОбработкаСсылка");
//       ИдентификаторКоманды = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ИдентификаторКоманды");
//   
//   Пример чтения значений дополнительных настроек:
//       Если ЗначениеЗаполнено(ОбъектСсылка) Тогда
//       	ХранилищеНастроек = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектСсылка, "ХранилищеНастроек");
//       	Настройки = ХранилищеНастроек.Получить();
//       	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
//       		ЗаполнитьЗначенияСвойств(ЭтотОбъект, "<ИменаНастроек>");
//       	КонецЕсли;
//       КонецЕсли;
//   
//   Пример сохранения значений дополнительных настроек:
//       Настройки = Новый Структура("<ИменаНастроек>", <ЗначенияНастроек>);
//       ДополнительнаяОбработкаОбъект = ОбъектСсылка.ПолучитьОбъект();
//       ДополнительнаяОбработкаОбъект.ХранилищеНастроек = Новый ХранилищеЗначения(Настройки);
//       ДополнительнаяОбработкаОбъект.Записать();
//
// Возвращаемое значение:
//   Строка - имя типа команд по открытию формы.
//
Функция ТипКомандыОткрытиеФормы() Экспорт
	
	Возврат "ОткрытиеФормы"; // Внутренний идентификатор.
	
КонецФункции

// Возвращает имя типа команд по заполнению формы без записи объекта. Данные команды доступны
//   только в обработках заполнения (Вид = "ЗаполнениеОбъекта").
//   Для выполнения команд такого типа в модуле объекта следует определить экспортную процедуру по шаблону:
//       // Обработчик серверных команд.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ОбъектыНазначения    - Массив - ссылки объектов, для которых вызвана команда.
//       //       - Неопределено - не передается для команд типа "ЗаполнениеФормы".
//       //   ПараметрыВыполнения  - Структура - контекст выполнения команды.
//       //       * ЭтаФорма - ФормаКлиентскогоПриложения - заполняемая форма. Передается для команд типа "ЗаполнениеФормы".
//       //       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - ссылка обработки.
//       //           Может использоваться для чтения параметров обработки.
//       //           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//       //
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения, ПараметрыВыполнения) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//
// Возвращаемое значение:
//   Строка - имя типа команд по заполнению формы.
//
Функция ТипКомандыЗаполнениеФормы() Экспорт
	
	Возврат "ЗаполнениеФормы"; // Внутренний идентификатор.
	
КонецФункции

// Возвращает имя типа команд по загрузке данных из файла. Данные команды доступны
//   только в глобальных обработках (Вид = "ДополнительнаяОбработка")
//   при наличии в конфигурации подсистемы "ЗагрузкаДанныхИзФайла".
//   Для выполнения команд такого типа в модуле объекта следует определить экспортные процедуры по шаблону:
//       // Определяет параметры загрузки данных из файла.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ПараметрыЗагрузки - Структура - настройки загрузки данных:
//       //       * ИмяМакетаСШаблоном - Строка - имя макета с шаблоном загружаемых данных.
//       //           По умолчанию используется макет "ЗагрузкаИзФайла".
//       //       * ОбязательныеКолонкиМакета - Массив - список имен колонок обязательных для заполнения.
//       //
//       Процедура ОпределитьПараметрыЗагрузкиДанныхИзФайла(ИдентификаторКоманды, ПараметрыЗагрузки) Экспорт
//       	// Переопределение настроек загрузки данных из файла.
//       КонецПроцедуры
//       
//       // Сопоставляет загружаемые данные с данными в информационной базе.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ЗагружаемыеДанные - ТаблицаЗначений - описание загружаемых данных:
//       //       * СопоставленныйОбъект - СправочникСсылка.Ссылка - ссылка на сопоставленный объект.
//       //           Заполняется внутри этой процедуры.
//       //       * <другие колонки> - Строка - данные, загруженные из файла.
//       //           Состав колонок соответствует макету "ЗагрузкаИзФайла".
//       //
//       Процедура СопоставитьЗагружаемыеДанныеИзФайла(ИдентификаторКоманды, ЗагружаемыеДанные) Экспорт
//       	// Реализация логики поиска данных в программе.
//       КонецПроцедуры
//       
//       // Загружает сопоставленные данные в базу.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ЗагружаемыеДанные - ТаблицаЗначений - описание загружаемых данных:
//       //       * СопоставленныйОбъект - СправочникСсылка - ссылка на сопоставленный объект.
//       //       * РезультатСопоставленияСтроки - Строка - статус загрузки. Возможны варианты: Создан, Обновлен, Пропущен.
//       //       * ОписаниеОшибки   - Строка - расшифровка ошибки загрузки данных.
//       //       * Идентификатор    - Число  - уникальный номер строки.
//       //       * <другие колонки> - Строка - данные, загруженные из файла.
//       //           Состав колонок соответствует макету "ЗагрузкаИзФайла".
//       //   ПараметрыЗагрузки - Структура - параметры с пользовательскими установками загрузки данных.
//       //       * СоздаватьНовые        - Булево - требуется ли создавать новые элементы справочника.
//       //       * ОбновлятьСуществующие - Булево - требуется ли обновлять элементы справочника.
//       //   Отказ - Булево - признак отмены загрузки.
//       //
//       Процедура ЗагрузитьИзФайла(ИдентификаторКоманды, ЗагружаемыеДанные, ПараметрыЗагрузки, Отказ) Экспорт
//       	// Реализация логики загрузки данных в программу.
//       КонецПроцедуры
//
// Возвращаемое значение:
//   Строка - имя типа команд по загрузке данных из файла.
//
Функция ТипКомандыЗагрузкаДанныхИзФайла() Экспорт
	
	Возврат "ЗагрузкаДанныхИзФайла"; // Внутренний идентификатор.
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Имена типов форм. Используются при настройке назначаемых объектов.

// Идентификатор формы списка.
//
// Возвращаемое значение:
//   Строка - идентификатор форм списков.
//
Функция ТипФормыСписка() Экспорт
	
	Возврат "ФормаСписка"; // Внутренний идентификатор.
	
КонецФункции

// Идентификатор формы объекта.
//
// Возвращаемое значение:
//   Строка - идентификатор форм объектов.
//
Функция ТипФормыОбъекта() Экспорт
	
	Возврат "ФормаОбъекта"; // Внутренний идентификатор.
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Другие процедуры и функции.

// Фильтр для диалогов выбора или сохранения дополнительных отчетов и обработок.
//
// Возвращаемое значение:
//   Строка - фильтр для диалогов выбора или сохранения дополнительных отчетов и обработок.
//
Функция ФильтрДиалоговВыбораИСохранения() Экспорт
	
	Фильтр = НСтр("ru = 'Внешние отчеты и обработки (*.%1, *.%2)|*.%1;*.%2|Внешние отчеты (*.%1)|*.%1|Внешние обработки (*.%2)|*.%2'");
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Фильтр, "erf", "epf");
	Возврат Фильтр;
	
КонецФункции

// Имя раздела, соответствующего начальной странице.
//
// Возвращаемое значение:
//   Строка - имя раздела, соответствующего начальной странице.
//
Функция ИмяНачальнойСтраницы() Экспорт
	
	Возврат "РабочийСтол"; 
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ДополнительныеОтчетыИОбработкиКлиентСервер.ИмяНачальнойСтраницы.
// Имя раздела, соответствующего начальной странице.
//
// Возвращаемое значение:
//   Строка
//
Функция ИдентификаторРабочегоСтола() Экспорт
	
	Возврат "РабочийСтол"; 
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет, задано ли расписание регламентного задания.
//
// Параметры:
//   Расписание - РасписаниеРегламентногоЗадания - расписание регламентного задания.
//
// Возвращаемое значение:
//   Булево - Истина, если расписание регламентного задания задано.
//
Функция РасписаниеЗадано(Расписание) Экспорт
	
	Возврат Расписание = Неопределено
		Или Строка(Расписание) <> Строка(Новый РасписаниеРегламентногоЗадания);
	
КонецФункции

#КонецОбласти
