
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


// Получить спецификации.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Получить спецификации
Функция ПолучитьПользователей() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Пользователи.user_id КАК Идентификатор,
		|	Пользователи.user_name КАК Наименование
		|ИЗ
		|	РегистрСведений.Пользователи КАК Пользователи";
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаЗначений = РезультатЗапроса.Выгрузить();
	ТаблицаЗначений.Индексы.Добавить("Идентификатор");	
	
	Возврат ТаблицаЗначений;	
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
