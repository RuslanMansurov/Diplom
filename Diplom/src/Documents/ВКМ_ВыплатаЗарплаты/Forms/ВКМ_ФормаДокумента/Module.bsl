//{{ВКМ. Автозаполнение по остаткам регистра ВКМ_ВзаиморасчетыССотрудникамиОстатки на дату документа 
&НаКлиенте
Процедура ВКМ_Автозаполнение(Команда)
	ВКМ_АвтозаполнениеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВКМ_АвтозаполнениеНаСервере() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВКМ_Сотрудник КАК Сотрудник,
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВКМ_СуммаОстаток КАК СуммаОстаток,
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВКМ_ВидРасчета КАК ВидРасчета
	|ИЗ
	|	РегистрНакопления.ВКМ_ВзаиморасчетыССотрудниками.Остатки(&Дата, ) КАК ВКМ_ВзаиморасчетыССотрудникамиОстатки";
	
	Запрос.УстановитьПараметр("Дата", Объект.Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Объект.ВКМ_Выплаты.Очистить();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТЧ = Объект.ВКМ_Выплаты.Добавить();
		СтрокаТЧ.ВКМ_Сотрудник = ВыборкаДетальныеЗаписи.Сотрудник;
		СтрокаТЧ.ВКМ_ВидРасчета = ВыборкаДетальныеЗаписи.ВидРасчета;
		СтрокаТЧ.ВКМ_Сумма = ВыборкаДетальныеЗаписи.СуммаОстаток;
	КонецЦикла; 
	
КонецПроцедуры
//}}ВКМ.


