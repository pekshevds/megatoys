///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Автор");	
	Результат.Добавить("Ответственный");	
	Результат.Добавить("Комментарий");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.Взаимодействия

// Конец СтандартныеПодсистемы.Взаимодействия

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ответственный, Отключено КАК Ложь)
	|	ИЛИ ЗначениеРазрешено(Автор, Отключено КАК Ложь)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом


// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//  КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ВыработкаИсполнителей";
	КомандаПечати.Представление = НСтр("ru = 'Выработка исполнителей'");	
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Выработка";
	КомандаПечати.Представление = НСтр("ru = 'Выработка'");	
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;

КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ВыработкаИсполнителей");
    Если НужноПечататьМакет Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ВыработкаИсполнителей", 
			НСтр("ru = 'Выработка исполнителей'"),
        	ПечатьВыработкиИсполнителей(МассивОбъектов, ОбъектыПечати), , "Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_ВыработкаИсполнителей");
    КонецЕсли;
    
    НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Выработка");
    Если НужноПечататьМакет Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"Выработка", 
			НСтр("ru = 'Выработка'"),
        	ПечатьВыработки(МассивОбъектов, ОбъектыПечати), , "Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_Выработка");
	КонецЕсли;
		
КонецПроцедуры

Функция ПечатьВыработкиИсполнителей(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ПроизводственнаяОперацияСводная_ВыработкаИсполнителей";
			
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТехнологическиеОперации.Ответственный,
	|	ТехнологическиеОперации.ТехнологическаяОперация,
	|	ТехнологическиеОперации.ТехнологическаяОперацияКоличество КАК Количество,
	|	ТехнологическиеОперации.ТехнологическаяОперацияВремяВыполнения КАК ВремяВыполнения,
	|	ТехнологическиеОперации.ТехнологическаяОперацияЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТехнологическиеОперации.ВидСтадииОбработки,
	|	ТехнологическиеОперации.Ссылка КАК Ссылка,
	|	ТехнологическиеОперации.Ссылка.Номер,
	|	ТехнологическиеОперации.Ссылка.Дата
	|ИЗ
	|	Документ.mega_ПроизводственнаяОперацияСводная.ТехнологическиеОперации КАК ТехнологическиеОперации
	|ГДЕ
	|	ТехнологическиеОперации.Ссылка В (&МассивОбъектов)
	|ИТОГИ
	|ПО
	|	Ссылка";
	
	Шапка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_ВыработкаИсполнителей");
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заголовок = СтрШаблон("Выработка исполнителей %1 от %2", Шапка.Номер, Шапка.Дата);		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		
		ТехнологическиеОперации = Шапка.Выбрать();
		Пока ТехнологическиеОперации.Следующий() Цикл 
			
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");
			ОбластьМакета.Параметры.Заполнить(ТехнологическиеОперации);
			
			ДатаЧастями = mega_МетодыРаботыСДатами.ПолучитьДатуЧастями(ТехнологическиеОперации.ВремяВыполнения);
			ВремяВЧасахМинутах = mega_МетодыРаботыСДатами.ПолучитьВремяВЧасахМинутахСекундахСтрокой(ДатаЧастями);
				
			ОбластьМакета.Параметры.ВремяВыполнения = ВремяВЧасахМинутах;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;		
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
				
	КонецЦикла;

	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьВыработки(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ПроизводственнаяОперацияСводная_Выработка";
			
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТехнологическиеОперации.Ответственный,
	|	ТехнологическиеОперации.Номенклатура,
	|	ТехнологическиеОперации.Количество,
	|	ТехнологическиеОперации.ЕдиницаИзмерения,
	|	ТехнологическиеОперации.ВидСтадииОбработки,
	|	ТехнологическиеОперации.Ссылка КАК Ссылка,
	|	ТехнологическиеОперации.Ссылка.Номер,
	|	ТехнологическиеОперации.Ссылка.Дата
	|ИЗ
	|	Документ.mega_ПроизводственнаяОперацияСводная.ТехнологическиеОперации КАК ТехнологическиеОперации
	|ГДЕ
	|	ТехнологическиеОперации.Ссылка В (&МассивОбъектов)
	|ИТОГИ
	|ПО
	|	Ссылка";
	
	Шапка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_Выработка");
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заголовок = СтрШаблон("Выработка %1 от %2", Шапка.Номер, Шапка.Дата);		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		
		ТехнологическиеОперации = Шапка.Выбрать();
		Пока ТехнологическиеОперации.Следующий() Цикл 
			
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");
			ОбластьМакета.Параметры.Заполнить(ТехнологическиеОперации);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;		
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
				
	КонецЦикла;

	Возврат ТабличныйДокумент;
	
КонецФункции

// Конец СтандартныеПодсистемы.Печать


// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Команда = СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.Встреча);
	Если Команда <> Неопределено Тогда
		Команда.ФункциональныеОпции = "ИспользоватьПрочиеВзаимодействия";
		Команда.Важность = "СмТакже";
	КонецЕсли;
	
	Возврат Команда;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#КонецЕсли
