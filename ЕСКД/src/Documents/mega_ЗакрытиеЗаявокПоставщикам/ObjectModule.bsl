///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьПоОстаткам()Экспорт
	
	Если ЭтоНовый() Тогда
		
		ДатаСреза = ТекущаяДатаСеанса();
	Иначе
		
		ДатаСреза = Новый Граница(ЭтотОбъект.Дата, ВидГраницы.Исключая);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗавкиПоставщикамОстатки.ДокументПотребности КАК ЗаявкаПоставщику
		|ИЗ
		|	РегистрНакопления.mega_ЗавкиПоставщикам.Остатки(&ДатаСреза,) КАК ЗавкиПоставщикамОстатки
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДокументПотребности";
	
	Запрос.УстановитьПараметр("ДатаСреза", ДатаСреза);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НоваяСтрока = Состав.Добавить();
		НоваяСтрока.ЗаявкаПоставщику = ВыборкаДетальныеЗаписи.ЗаявкаПоставщику;
	КонецЦикла;
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
    	
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	
	ДатаСреза = Новый Граница(ЭтотОбъект.Дата, ВидГраницы.Исключая);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&ВидДвижения КАК ВидДвижения,
	|	&Период КАК Период,
	|	Остатки.Номенклатура КАК Номенклатура,
	|	Остатки.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаХранения,
	|	Остатки.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Остатки.ДокументПотребности КАК ДокументПотребности,
	|	Остатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.mega_ЗавкиПоставщикам.Остатки(&ДатаСреза, ДокументПотребности В
	|		(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			Состав.ЗаявкаПоставщику
	|		ИЗ
	|			Документ.mega_ЗакрытиеЗаявокПоставщикам.Состав КАК Состав
	|		ГДЕ
	|			Состав.Ссылка = &Регистратор)) КАК Остатки";
	
	Запрос.УстановитьПараметр("Регистратор", ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("Период", ЭтотОбъект.Дата);
	Запрос.УстановитьПараметр("ДатаСреза", ДатаСреза);
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Расход);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
    		
	РегистрыНакопления.mega_ЗавкиПоставщикам.ВыполнитьДвижение(ЭтотОбъект.Ссылка, Выборка);	
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

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли