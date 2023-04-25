
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


// Получить спецификации.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Получить спецификации
Функция ПолучитьСпецификации() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Спецификации.specification_id КАК Идентификатор,
		|	Спецификации.specification_name КАК Наименование
		|ИЗ
		|	РегистрСведений.Спецификации КАК Спецификации";
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаЗначений = РезультатЗапроса.Выгрузить();
	ТаблицаЗначений.Индексы.Добавить("Идентификатор");	
	
	Возврат ТаблицаЗначений;	
КонецФункции


// Получить виды стадий обработки.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Получить виды стадий обработки
Функция ПолучитьВидыСтадийОбработки() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Спецификации.stage_id КАК Идентификатор,
		|	Спецификации.stage_name КАК Наименование
		|ИЗ
		|	РегистрСведений.Спецификации КАК Спецификации";
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаЗначений = РезультатЗапроса.Выгрузить();
	ТаблицаЗначений.Индексы.Добавить("Идентификатор");	
	
	Возврат ТаблицаЗначений;	
КонецФункции


// Получить виды стадий обработки спецификации.
// 
// Параметры:
//  ИдентификаторСпецификации - Строка - Идентификатор спецификации
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Получить виды стадий обработки спецификации
Функция ПолучитьВидыСтадийОбработкиСпецификации(ИдентификаторСпецификации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Спецификации.stage_id КАК Идентификатор,
		|	Спецификации.stage_name КАК Наименование,
		|	Спецификации.index КАК НомерСтроки,
		|	Спецификации.qnt КАК Количество
		|ИЗ
		|	РегистрСведений.Спецификации КАК Спецификации
		|ГДЕ
		|	Спецификации.specification_id = &id
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("id", ИдентификаторСпецификации);
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаЗначений = РезультатЗапроса.Выгрузить();	
	
	Возврат ТаблицаЗначений;	
КонецФункции


// Получить атрибуты спецификации.
// 
// Параметры:
//  ИдентификаторСпецификации - Строка - спецификации
// 
// Возвращаемое значение:
//  Структура - Получить атрибуты спецификации:
// * Идентификатор - Строка - Идентификатор спецификации
// * Наименование - Строка - Наименование спецификации
Функция ПолучитьАтрибутыСпецификации(ИдентификаторСпецификации) Экспорт
	
	АтрибутыСпецификации = Новый Структура;
	АтрибутыСпецификации.Вставить("Идентификатор", "");
	АтрибутыСпецификации.Вставить("Наименование", "");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
		|	Спецификации.specification_id КАК Идентификатор,
		|	Спецификации.specification_name КАК Наименование
		|ИЗ
		|	РегистрСведений.Спецификации КАК Спецификации
		|ГДЕ
		|	Спецификации.specification_id = &id";
	Запрос.УстановитьПараметр("id", ИдентификаторСпецификации);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выбора = РезультатЗапроса.Выбрать();
	
	Если Выбора.Следующий() Тогда
	
		ЗаполнитьЗначенияСвойств(АтрибутыСпецификации, Выбора);
	КонецЕсли;
	
	Возврат АтрибутыСпецификации;
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

// Код процедур и функций

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ДобавитьЗапись(ПараметрыЗаписи) Экспорт
	
	Попытка
		
		МенеджерЗаписи = СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ПараметрыЗаписи);
		МенеджерЗаписи.Записать();		
	Исключение
		
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Код процедур и функций

#КонецОбласти

#КонецЕсли
