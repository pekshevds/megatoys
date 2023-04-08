///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОписаниеПеременных

Перем ТаблицаОстатковПроизводственныхРесурсов;
Перем ДатаНачалаПланирования;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
    	
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры


Процедура ОбработкаПроведения(Отказ, РежимПроведения)
			
	Движения.mega_ПроизводственныеРесурсы.Записывать = Истина;
	ОсвободитьРанееЗанятыеРесурсы();
	
	ДатаНачалаПланирования = НачалоДня(ТекущаяДатаСеанса());
	ИнициализироватьТаблицуОстатковПроизводственныхРесурсов();
	
	Для Каждого ТекСтрокаСостав Из Состав Цикл 
		
		ОперацииСпецификации = ПолучитьОперацииСпецификации(ТекСтрокаСостав.Спецификация, ТекСтрокаСостав.Количество);		
		ВремяВыполнения = ОперацииСпецификации.Итог("ВремяВыполнения");
		
		Пока ВремяВыполнения <> 0 Цикл 
			
			СоздатьПроводки(ОперацииСпецификации);
			ВремяВыполнения = ОперацииСпецификации.Итог("ВремяВыполнения");
		КонецЦикла;				
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
		
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОсвободитьРанееЗанятыеРесурсы()            
	
	Движения.mega_ПроизводственныеРесурсы.Очистить();
	Движения.mega_ПроизводственныеРесурсы.Записать();	
КонецПроцедуры

Процедура ИнициализироватьТаблицуОстатковПроизводственныхРесурсов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроизводственныеРесурсы.Ресурс КАК Ресурс,
	|	ПроизводственныеРесурсы.ДатаРесурса КАК ДатаРесурса,
	|	ПроизводственныеРесурсы.ВремяОстаток КАК ВремяОстаток
	|ИЗ
	|	РегистрНакопления.mega_ПроизводственныеРесурсы.Остатки(, ДатаРесурса >= &ДатаНачалаПланирования) КАК ПроизводственныеРесурсы
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ресурс,
	|	ДатаРесурса";
	
	Запрос.УстановитьПараметр("ДатаНачалаПланирования", ДатаНачалаПланирования);
	
	Результат = Запрос.Выполнить();
	ТаблицаОстатковПроизводственныхРесурсов = Результат.Выгрузить();
	ТаблицаОстатковПроизводственныхРесурсов.Индексы.Добавить("Ресурс");
КонецПроцедуры

Функция ПолучитьОперацииСпецификации(Спецификация, Количество = 1)Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ                                             
	|	СтадииОбработки.НомерСтроки КАК НомерСтроки,
	|	СтадииОбработки.ВидСтадииОбработки КАК ВидСтадииОбработки,
	|	СтадииОбработки.Количество КАК НормаПроизводства,	
	|	ТехнологическиеОперации.Номенклатура КАК ТехнологическаяОперация,
	|	ТехнологическиеОперации.Номенклатура.ПроизводственныйРесурс КАК ПроизводственныйРесурс,	
	|	ТехнологическиеОперации.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	&Количество КАК Количество,
	|	ТехнологическиеОперации.ВремяВыполнения / ТехнологическиеОперации.Ссылка.Количество КАК ВремяВыполненияЕдиницы,
	|	ТехнологическиеОперации.ВремяВыполнения / ТехнологическиеОперации.Ссылка.Количество * &Количество КАК ВремяВыполнения,
	|	СтадииОбработки.Ссылка КАК Спецификация
	|ИЗ
	|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК ТехнологическиеОперации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.mega_Спецификации.СтадииОбработки КАК СтадииОбработки
	|		ПО ТехнологическиеОперации.Ссылка = СтадииОбработки.Ссылка
	|			И ТехнологическиеОперации.КлючСвязи = СтадииОбработки.КлючСвязи
	|ГДЕ
	|	ТехнологическиеОперации.Ссылка = &Спецификация
	|	И ТехнологическиеОперации.Номенклатура.ПроизводственныйРесурс <> ЗНАЧЕНИЕ(Справочник.mega_ПроизводственныеРесурсы.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
		
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("Количество", Количество);
	РезультатЗапроса = Запрос.Выполнить();
				
	Возврат РезультатЗапроса.Выгрузить();
КонецФункции

Функция ПолучитьОстаткиПроизводственногоРесурса(ПроизводственныйРесурс)
	
	Строки = ТаблицаОстатковПроизводственныхРесурсов.НайтиСтроки(Новый Структура("Ресурс", ПроизводственныйРесурс));
	Возврат Строки;
КонецФункции

Процедура СоздатьПроводки(ОперацииСпецификации)
	
	Для Каждого Операция Из ОперацииСпецификации Цикл 
		
		Время = Операция.ВремяВыполненияЕдиницы * Операция.НормаПроизводства;
		ОстаткиПроизводственногоРесурса = ПолучитьОстаткиПроизводственногоРесурса(Операция.ПроизводственныйРесурс);
					
		Для Каждого СтрокаОстатков Из ОстаткиПроизводственногоРесурса Цикл
			
			Если Время <= СтрокаОстатков.ВремяОстаток Тогда
				
				Движение = Движения.mega_ПроизводственныеРесурсы.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.ДатаРесурса = СтрокаОстатков.ДатаРесурса;
				Движение.Ресурс = Операция.ПроизводственныйРесурс;			
				Движение.Время = Время;		
				Движение.Спецификация = Операция.Спецификация;
				Движение.ВидСтадииОбработки = Операция.ВидСтадииОбработки;
				Движение.ТехнологическаяОперация = Операция.ТехнологическаяОперация;
				
				Операция.ВремяВыполнения = Операция.ВремяВыполнения - Время;
				
				СтрокаОстатков.ВремяОстаток = СтрокаОстатков.ВремяОстаток - Время;
				Время = 0;
				Прервать;
			КонецЕсли;				
		КонецЦикла;
		Если Время > 0 Тогда
			
			СообщениеИсключения =  СтрШаблон(
			"Для технологической операции %1
			|нет свободного остатка ресурса %2", 
			Операция.ТехнологическаяОперация, Операция.ПроизводственныйРесурс);
			ВызватьИсключение СообщениеИсключения;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли