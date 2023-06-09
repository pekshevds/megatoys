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
	
	Если Параметры.Свойство("КомандаВвестиСледующую") Тогда 
		
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		ДокументОбъект.ЗаполнитьНаОснованииПроизводственнойОперации(Параметры.Основание);
        ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	КонецЕсли;
КонецПроцедуры   

&НаКлиенте
Процедура ПриОткрытии(Отказ)  
	
	УправлениеДоступностью();
	
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

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидСтадииОбработкиПриИзменении(Элемент)
	
	ВидСтадииОбработкиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	КоличествоПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

&НаСервере
Процедура НоменклатураПриИзмененииНаСервере()
	
	Объект.ЕдиницаИзмерения = Объект.Номенклатура.ЕдиницаИзмерения;
	Объект.Спецификация = Справочники.mega_Спецификации.ПолучитьОсновнуюСпецификациюНоменклатуры(Объект.Номенклатура);
	ПерваяСтадияОбработки = Справочники.mega_Спецификации.ПолучитьПервуюСтадиюОбработки(Объект.Спецификация);
	Объект.ВидСтадииОбработки = ПерваяСтадияОбработки.ВидСтадииОбработки;
	Объект.ПредыдущийВидСтадииОбработки = Неопределено;
КонецПроцедуры

&НаСервере
Процедура ВидСтадииОбработкиПриИзмененииНаСервере()
	Объект.ПредыдущийВидСтадииОбработки = Неопределено;
		
	Если ЗначениеЗаполнено(Объект.Спецификация) Тогда
		
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		ДокументОбъект.ЗаполнитьПредыдущуюСтадиюОбработки();
		ДокументОбъект.РассчитатьТабличныеЧасти();
        ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура КоличествоПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Спецификация) Тогда
		
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		ДокументОбъект.РассчитатьТабличныеЧасти();
        ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

