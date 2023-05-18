///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 		
КонецПроцедуры   

&НаКлиенте
Процедура ПриОткрытии(Отказ)  
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоПлануПроизводства(Команда)
	
	Если Объект.Состав.Количество() = 0 Тогда
		
		ЗаполнитьПоПлануПроизводстваНаСервере();
	Иначе
		Режим = РежимДиалогаВопрос.ДаНет;
		
		ОписаниеОповещенияОЗавершении = 
			Новый ОписаниеОповещения("ПослеЗакрытияВопросаОНеобходимостиЗаполненияПоПлануПроизводства", ЭтотОбъект);	
		
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, 
			НСтр("ru = 'Перед заполнением табличная часть будет очищена. Продолжить?';"), Режим, 0);		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Состав.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ТекущиеДанные.ВремяВыполнения = ТекущиеДанные.Количество * 
		ПолучитьДлительностьТехнологическойОперацииНаСервере(
			ТекущиеДанные.Спецификация, 
			ТекущиеДанные.ВидСтадииОбработки, 
			ТекущиеДанные.ТехнологическаяОперация);
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьДлительностьТехнологическойОперацииНаСервере(Спецификация, ВидСтадииОбработки, ТехнологическаяОперация)
    
    Запрос = Новый Запрос;
    Запрос.Текст =
    	"ВЫБРАТЬ
    	|	ТехнологическиеОперации.ВремяВыполнения / ТехнологическиеОперации.Количество КАК Время
    	|ИЗ
    	|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК ТехнологическиеОперации
    	|ГДЕ
    	|	ТехнологическиеОперации.КлючСвязи В
    	|		(ВЫБРАТЬ
    	|			СтадииОбработки.КлючСвязи
    	|		ИЗ
    	|			Справочник.mega_Спецификации.СтадииОбработки КАК СтадииОбработки
    	|		ГДЕ
    	|			СтадииОбработки.Ссылка = &Спецификация
    	|			И СтадииОбработки.ВидСтадииОбработки = &ВидСтадииОбработки)
    	|	И ТехнологическиеОперации.Номенклатура = &ТехнологическаяОперация";
    
    Запрос.УстановитьПараметр("Спецификация", Спецификация);
    Запрос.УстановитьПараметр("ТехнологическаяОперация", ТехнологическаяОперация);
    Запрос.УстановитьПараметр("ВидСтадииОбработки", ВидСтадииОбработки);
    
    РезультатЗапроса = Запрос.Выполнить();
    
    ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
    
    Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
    	Возврат ВыборкаДетальныеЗаписи.Время;
    КонецЦикла;
    
	Возврат 0;    
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияВопросаОНеобходимостиЗаполненияПоПлануПроизводства(Результат, Параметры) Экспорт
    
    Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
	
	Объект.Состав.Очистить();	
	ЗаполнитьПоПлануПроизводстваНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПлануПроизводстваНаСервере()
    
    ДокументОбъект = РеквизитФормыВЗначение("Объект");
    ДокументОбъект.ЗаполнитьПоПлануПроизводства();
   	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
КонецПроцедуры


// Управляет доступностью элементов формы.
&НаКлиенте
Процедура УправлениеДоступностью()
	

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти 

