//{{ВКМ. 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//{{ВКМ. Добавляем команду формирования Диаграммы Ганта 
	Команда = Команды.Добавить("Сформировать");
	Команда.Заголовок = "Сформировать";
	Команда.Действие = "ВКМ_СформироватьДиаграмму";
	
	КнопкаФормы = Элементы.Добавить("Сформировать", Тип("КнопкаФормы"), Элементы.ВКМ_ДиаграммаГантаТаблицаКоманднаяПанель);
	КнопкаФормы.ИмяКоманды = "Сформировать";
	КнопкаФормы.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
	//}}ВКМ 
	
	//{{ВКМ. Получение данных Табличной части Основной формы
	ДанныеФормыОтпускаСотрудников = ПолучитьИзВременногоХранилища(Параметры.Адрес);
	Сотрудник = ДанныеФормыОтпускаСотрудников.ВыгрузитьКолонку("ВКМ_Сотрудник");
	Должность = ДанныеФормыОтпускаСотрудников.ВыгрузитьКолонку("ВКМ_Должность");
	ДатаНачала = ДанныеФормыОтпускаСотрудников.ВыгрузитьКолонку("ВКМ_ДатаНачала");
	ДатаОкончания = ДанныеФормыОтпускаСотрудников.ВыгрузитьКолонку("ВКМ_ДатаОкончания");
	ДнейОтпуска = ДанныеФормыОтпускаСотрудников.ВыгрузитьКолонку("ВКМ_ДнейОтпуска");
	КоличествоЗаписей = Сотрудник.Количество();
	//}}ВКМ 
	
	//{{ВКМ. Запись полученных данных в Табличную часть Дополнительной формы
	Н = 0; 
	Пока Н <= (КоличествоЗаписей - 1) Цикл
		СтрокаТЧ = Объект.ВКМ_ОтпускаСотрудников.Добавить();
		СтрокаТЧ.ВКМ_Сотрудник = Сотрудник[Н];
		СтрокаТЧ.ВКМ_Должность = Должность[Н];
		СтрокаТЧ.ВКМ_ДатаНачала = ДатаНачала[Н];
		СтрокаТЧ.ВКМ_ДатаОкончания = ДатаОкончания[Н];
		СтрокаТЧ.ВКМ_ДнейОтпуска = ДнейОтпуска[Н];
		Н = Н+1;
	КонецЦикла;  
	
	ВКМ_СформироватьДиаграммуНаСервере(ЭтотОбъект.ВКМ_ДиаграммаГанта);
	//}}ВКМ 
	
КонецПроцедуры    

&НаКлиенте
Процедура ВКМ_СформироватьДиаграмму(Команда) 
	ВКМ_СформироватьДиаграммуНаСервере(ЭтотОбъект.ВКМ_ДиаграммаГанта);
КонецПроцедуры      

&НаСервере
Процедура ВКМ_СформироватьДиаграммуНаСервере(ВКМ_ДиаграммаГанта) 
	
	//ВКМ. Установить заголовок диаграммы. 
	ВКМ_ДиаграммаГанта.ОбластьЗаголовка.Текст = "Месяцы";
	
	ВКМ_ДиаграммаГанта.ОтображатьЛегенду = Ложь;  
	
	// ВКМ. Заполнение диаграммы Ганта.
	ВКМ_ДиаграммаГанта.Обновление = Ложь;
	ВКМ_ДиаграммаГанта.Очистить(); 
	
	Для Каждого ТекСтрока Из Объект.ВКМ_ОтпускаСотрудников Цикл
		
		УстановитьТочку = ВКМ_ДиаграммаГанта.УстановитьТочку(ТекСтрока.ВКМ_Сотрудник);
		УстановитьСерию = ВКМ_ДиаграммаГанта.УстановитьСерию("Отпуск");
		УстановитьСерию.Цвет = WebЦвета.ЗеленыйЛес;
		Значение = ВКМ_ДиаграммаГанта.ПолучитьЗначение(УстановитьТочку, УстановитьСерию);
		Интервал = Значение.Добавить();
		Интервал.Начало = ТекСтрока.ВКМ_ДатаНачала;
		Интервал.Конец = ТекСтрока.ВКМ_ДатаОкончания;
		
	КонецЦикла;   
	
	ВКМ_ДиаграммаГанта.Обновление = Истина; 
	
КонецПроцедуры      
//}}ВКМ

