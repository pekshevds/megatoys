///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЗаявкаПоставщику";
	КомандаПечати.Представление = НСтр("ru = 'Заявка поставщику'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Заявка поставщику'");
	КомандаПечати.СписокФорм    = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ДополнительныеПараметры.Вставить("НеВыводитьВКомплекте",Истина);
	КомандаПечати.Порядок       = 10;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЗаявкаПоставщикуВНоменклатуреПоставщика";
	КомандаПечати.Представление = НСтр("ru = 'Заявка поставщику (в его номенклатуре)'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Заявка поставщику (в его номенклатуре)'");
	КомандаПечати.СписокФорм    = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ДополнительныеПараметры.Вставить("НеВыводитьВКомплекте",Истина);
	КомандаПечати.Порядок       = 11;	
	
КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаявкаПоставщику") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ЗаявкаПоставщику",
			"Заявка поставщику", 
			ПечатьЗаявкиПоставщику(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),, 
			"Документ.mega_ЗаявкаПоставщику.ПФ_MXL_ЗаявкаПоставщику");
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаявкаПоставщикуВНоменклатуреПоставщика") Тогда
		
		ПараметрыПечати.Вставить("ВНоменклатуреПоставщика", Истина);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ЗаявкаПоставщикуВНоменклатуреПоставщика",
			"Заявка поставщику (в его номенклатуре)", 
			ПечатьЗаявкиПоставщику(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),, 
			"Документ.mega_ЗаявкаПоставщику.ПФ_MXL_ЗаявкаПоставщику");
	КонецЕсли;
		
КонецПроцедуры

// Функция формирует табличный документ с печатной формой накладной,
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьЗаявкиПоставщику(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)

	УстановитьПривилегированныйРежим(Истина);
	
	ВНоменклатуреПоставщика = 
		ПараметрыПечати.Свойство("ВНоменклатуреПоставщика") И ПараметрыПечати.ВНоменклатуреПоставщика;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявкаПоставщику_ПечатнаяФорма";
			
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Документ.Ссылка КАК Ссылка,
	|	Документ.Номер КАК Номер,
	|	Документ.Дата КАК Дата,
	|	Документ.Автор КАК Автор,
	|	Документ.Поставщик КАК Поставщик,
	|	Документ.Ответственный КАК Ответственный,
	|	Документ.Состав.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Номенклатура,
	|		Номенклатура.Код КАК Идентификатор,
	|		ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		Количество КАК Количество,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма,
	|	) КАК Состав
	|ИЗ
	|	Документ.mega_ЗаявкаПоставщику КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивОбъектов)";
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.mega_ЗаявкаПоставщику.ПФ_MXL_ЗаявкаПоставщику");

		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.Заголовок = 
			СтрШаблон("Заявка поставщику №%1 от %2", Шапка.Номер, Формат(Шапка.Дата, "ДФ='dd.MM.yyyy ""г""';"));		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		
		Состав = Шапка.Состав.Выбрать();
		Пока Состав.Следующий() Цикл 
			
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");
			ОбластьМакета.Параметры.Заполнить(Состав);
			
			Если ВНоменклатуреПоставщика Тогда
				
				ОбластьМакета.Параметры.Идентификатор = "";
				ОбластьМакета.Параметры.Номенклатура = "";
				
				ВыборкаДетальныеЗаписи = 
					Справочники.mega_НоменклатураПоставщиков.ПолучитьНоменклатуруПоставщика(
						Состав.Номенклатура, Шапка.Поставщик);
						
				Если ВыборкаДетальныеЗаписи.Следующий() Тогда
					ОбластьМакета.Параметры.Идентификатор = ВыборкаДетальныеЗаписи.Код;
					ОбластьМакета.Параметры.Номенклатура = ВыборкаДетальныеЗаписи.Ссылка;
				КонецЕсли;
			КонецЕсли;
			
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
