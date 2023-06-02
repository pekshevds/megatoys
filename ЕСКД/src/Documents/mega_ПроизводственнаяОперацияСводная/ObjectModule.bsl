///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


// Заполняет "Материалы спецификаций" и "Материалы" по данным спецификаций операций
Процедура ЗаполнитьМатериалы() Экспорт 
	
	Спецификации = ПолучитьСпецификацииДокумента();	
	МатериалыСпецификаций = ПолучитьМатериалыСпецификаций(Спецификации);	
	
	Для Каждого ТекСтрокаТехнологическиеОперации Из ТехнологическиеОперации Цикл
		
		Если ЗначениеЗаполнено(ТекСтрокаТехнологическиеОперации.Спецификация) И 
			ЗначениеЗаполнено(ТекСтрокаТехнологическиеОперации.ВидСтадииОбработки) Тогда
			
			СтадияОбработкиПоВидуСтадииОбработки = 
				Справочники.mega_Спецификации.ПолучитьСтадиюОбработкиПоВидуСтадииОбработки(ТекСтрокаТехнологическиеОперации.Спецификация,
					ТекСтрокаТехнологическиеОперации.ВидСтадииОбработки);
			
			ПараметрыПоиска = Новый Структура;
			ПараметрыПоиска.Вставить("Спецификация", ТекСтрокаТехнологическиеОперации.Спецификация);
			ПараметрыПоиска.Вставить("КлючСвязи", СтадияОбработкиПоВидуСтадииОбработки.КлючСвязи);
			
			МатериалыСпецификаций.Сбросить();
			Пока МатериалыСпецификаций.НайтиСледующий(ПараметрыПоиска) Цикл
				
				НоваяСтрока = МатериалыОпераций.Добавить();
				НоваяСтрока.КлючСвязи = ТекСтрокаТехнологическиеОперации.КлючСвязи;
				НоваяСтрока.Номенклатура = МатериалыСпецификаций.Материал;
				НоваяСтрока.ЕдиницаИзмерения = МатериалыСпецификаций.ЕдиницаИзмерения;
				НоваяСтрока.Количество = МатериалыСпецификаций.Количество * ТекСтрокаТехнологическиеОперации.Количество;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьМатериалыПоМатериаламОпераций();
КонецПроцедуры //ЗаполнитьМатериалы

#Область ДляВызоваИзДругихПодсистем

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
    	
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// регистр mega_ПроизводственныеЗапасы Приход	
	Движения.mega_ПроизводственныеЗапасы.Записывать = Истина;
	Движения.mega_ВыработкаИсполнителей.Записывать = Истина;
	
	Для Каждого ТекСтрока Из ТехнологическиеОперации Цикл
		
		//Запасы
		Движение = Движения.mega_ПроизводственныеЗапасы.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрока.Номенклатура;
		Движение.ВидСтадииОбработки = ТекСтрока.ВидСтадииОбработки;
		Движение.Количество = ТекСтрока.Количество;
		
		Если ЗначениеЗаполнено(ТекСтрока.ПредыдущийВидСтадииОбработки) Тогда 
			
			Движение = Движения.mega_ПроизводственныеЗапасы.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Номенклатура = ТекСтрока.Номенклатура;
			Движение.ВидСтадииОбработки = ТекСтрока.ПредыдущийВидСтадииОбработки;
			Движение.Количество = ТекСтрока.Количество;		
		КонецЕсли;
		
		//Работы
		Движение = Движения.mega_ВыработкаИсполнителей.Добавить();		
		Движение.Период = Дата;
		Движение.Исполнитель = ТекСтрока.Ответственный;
		Движение.ТехнологическаяОперация = ТекСтрока.ТехнологическаяОперация;
		Движение.Количество = ТекСтрока.ТехнологическаяОперацияКоличество;
		Движение.Время = ТекСтрока.ТехнологическаяОперацияВремяВыполнения;
	КонецЦикла;
		
	//Материалы
	Для Каждого ТекСтрока Из Материалы Цикл 
		
		Движение = Движения.mega_ПроизводственныеЗапасы.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрока.Номенклатура;		
		Движение.Количество = ТекСтрока.Количество;
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

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
    
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


// Возвращает массив уникальных спецификаций операций документа
// 
// Возвращаемое значение:
//  Массив Из СправочникСсылка.mega_Спецификации
Функция ПолучитьСпецификацииДокумента()
	
	ВременныеТехнологическиеОперации = ТехнологическиеОперации.Выгрузить();
	ВременныеТехнологическиеОперации.Свернуть("Спецификация");
	Возврат ВременныеТехнологическиеОперации.ВыгрузитьКолонку("Спецификация");
КонецФункции //ПолучитьСпецификацииДокумента()


// Сворачивает "Материалы операций" и загружает данные в "Материалы"
Процедура ЗаполнитьМатериалыПоМатериаламОпераций()
	
	ВремМатериалыОпераций = МатериалыОпераций.Выгрузить();
	ВремМатериалыОпераций.Свернуть("Номенклатура,ЕдиницаИзмерения,Спецификация", "Количество");
	Материалы.Загрузить(ВремМатериалыОпераций);
КонецПроцедуры //ЗаполнитьМатериалыПоМатериаламОпераций


// Получить материалы спецификаций.
// 
// Параметры:
//  Спецификации - Массив Из СправочникСсылка.mega_Спецификации
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса - Получить материалы спецификаций
Функция ПолучитьМатериалыСпецификаций(Спецификации)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МатериалыСпецификаций.Ссылка КАК Спецификация,
		|	МатериалыСпецификаций.Номенклатура КАК Материал,
		|	МатериалыСпецификаций.Количество / МатериалыСпецификаций.Ссылка.Количество КАК Количество,
		|	МатериалыСпецификаций.ЕдиницаИзмерения,
		|	МатериалыСпецификаций.СтадияОбработки,
		|	МатериалыСпецификаций.КлючСвязи
		|ИЗ
		|	Справочник.mega_Спецификации.Материалы КАК МатериалыСпецификаций
		|ГДЕ
		|	МатериалыСпецификаций.Ссылка В (&Спецификации)";
	
	Запрос.УстановитьПараметр("Спецификации", Спецификации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Возврат ВыборкаДетальныеЗаписи;
КонецФункции //ПолучитьМатериалыСпецификаций

Процедура ЗаполнитьТехнологическиеОперации()
	
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли