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


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
	
	Если Объект.Состав.Количество() = 0 Тогда
		
		ЗаполнитьПоОстаткамНаСервере();
	Иначе
		Режим = РежимДиалогаВопрос.ДаНет;
		
		ОписаниеОповещенияОЗавершении = 
			Новый ОписаниеОповещения("ПослеЗакрытияВопросаООчисткеТаблицыСостав", ЭтотОбъект);	
		
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, 
			НСтр("ru = 'Перед заполнением табличная часть будет очищена. Продолжить?';"), Режим, 0);		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Состав.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"Номенклатура,
		|ЕдиницаИзмерения,
		|Количество");
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);
		
		ПриИзмененииНоменклатурыНаСервере(Структура);
		
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеЗакрытияВопросаООчисткеТаблицыСостав(Результат, Параметры) Экспорт
    
    Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
	
	Объект.Состав.Очистить();
		
	ЗаполнитьПоОстаткамНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОстаткамНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
    ДокументОбъект.ЗаполнитьПоОстаткам();
   	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ЭтотОбъект.Модифицированность = Истина;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриИзмененииНоменклатурыНаСервере(Структура)
	
	Структура.ЕдиницаИзмерения = Справочники.mega_ЕдиницыИзмерения.ПустаяСсылка();	
			
	Если ЗначениеЗаполнено(Структура.Номенклатура) Тогда
		
		Структура.ЕдиницаИзмерения = 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Структура.Номенклатура, "ЕдиницаИзмерения");
	КонецЕсли;	
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
