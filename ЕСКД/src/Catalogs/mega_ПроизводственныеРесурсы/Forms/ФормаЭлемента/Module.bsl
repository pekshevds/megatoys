
&НаСервере
Процедура СоставПриИзмененииНаСервере()
	
	Объект.Время = Объект.Состав.Итог("Время");
КонецПроцедуры

&НаКлиенте
Процедура СоставПриИзменении(Элемент)
	СоставПриИзмененииНаСервере();
КонецПроцедуры
