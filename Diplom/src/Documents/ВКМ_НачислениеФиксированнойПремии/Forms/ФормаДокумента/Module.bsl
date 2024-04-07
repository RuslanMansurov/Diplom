//{{ВКМ. Получение запросом из Регистра сведений "ВКМ_УсловияОплатыСотрудников" значений процента премии
&НаКлиенте
Процедура ВКМ_НачисленияВКМ_СотрудникПриИзменении(Элемент)
	ТекДанные = Элементы.ВКМ_Начисления.ТекущиеДанные;
	Сотрудник = ТекДанные.ВКМ_Сотрудник;
	ВидРасчета = ТекДанные.ВКМ_ВидРасчета;
	Результат = ВКМ_НачисленияВКМ_СотрудникПриИзмененииНаСервере(Сотрудник, ВидРасчета);
	ТекДанные.ВКМ_ПроцентПремии = Результат;
КонецПроцедуры   

&НаКлиенте
	Процедура ВКМ_НачисленияВКМ_ВидРасчетаПриИзменении(Элемент)
	ТекДанные = Элементы.ВКМ_Начисления.ТекущиеДанные;
	Сотрудник = ТекДанные.ВКМ_Сотрудник;
	ВидРасчета = ТекДанные.ВКМ_ВидРасчета;
	Результат = ВКМ_НачисленияВКМ_СотрудникПриИзмененииНаСервере(Сотрудник, ВидРасчета);
	ТекДанные.ВКМ_ПроцентПремии = Результат;
	КонецПроцедуры

&НаСервере
Функция ВКМ_НачисленияВКМ_СотрудникПриИзмененииНаСервере(Сотрудник, ВидРасчета)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.Период КАК Период,
		|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.ВКМ_Сотрудник КАК ВКМ_Сотрудник,
		|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.ВКМ_Подразделение КАК ВКМ_Подразделение,
		|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.ВКМ_Оклад КАК ВКМ_Оклад,
		|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.ВКМ_ПроцентПремии КАК ВКМ_ПроцентПремии,
		|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.ВКМ_ПроцентФиксПремии КАК ВКМ_ПроцентФиксПремии
		|ИЗ
		|	РегистрСведений.ВКМ_УсловияОплатыСотрудников.СрезПоследних КАК ВКМ_УсловияОплатыСотрудниковСрезПоследних
		|ГДЕ
		|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.ВКМ_Сотрудник = &ВКМ_Сотрудник";
		
		Запрос.УстановитьПараметр("ВКМ_Сотрудник", Сотрудник);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();	 
		
		Если ВидРасчета <> Неопределено Тогда
			
			Если ВидРасчета.Наименование = "Премия за работы" Тогда
				ПроцентПремии = ВыборкаДетальныеЗаписи.ВКМ_ПроцентПремии;
			Иначе 
				ПроцентПремии = ВыборкаДетальныеЗаписи.ВКМ_ПроцентФиксПремии;
			КонецЕсли;
			
		Иначе   
			
			ПроцентПремии = 0;
			
		КонецЕсли;
		
		Возврат ПроцентПремии;
		
	КонецФункции
//}}ВКМ
