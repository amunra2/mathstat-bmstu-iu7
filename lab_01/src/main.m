function lab_01()
    X = csvread('data21.csv');
    
    X = sort(X);
    n = length(X);
    
    fprintf("\nn = %g\n", n); 
    
    fprintf("\nВыполнение заданий.\n\n");
    
    % Задание 1
    fprintf("\n1) Вычислить максимальное и минимальное значение:\n", n);
    
    % Минимальное значение
    minX = min(X);
    fprintf("\nМинимальное значение  = %.4f", minX);
    
    % Максимальное значение
    maxX = max(X);
    fprintf("\nМаксимальное значение = %.4f\n", maxX);
    
    
    % Задание 2
    fprintf("\n2) Вычислить размах R:\n", n);
    
    % Размах R
    R = maxX - minX;
    fprintf("\nR = %.4f\n", R);
    
    
    % Задание 3
    fprintf("\n3) Вычислить оценки математического ожидания и дисперсии:\n", n);
    % Выборочное среднее
    mu = sum(X) / n;
    fprintf("\nВыборочное среднее (оценка мат ожидания) = %.4f\n", mu);
    
    % Исправленная дисперсия
    s_quad = sum((X - mu) .^2) / (n - 1);
    fprintf("Исправленная дисперсия (оценка дисперсии) = %.4f\n", s_quad);
    
    
    % Задание 4
    fprintf("\n4) Группировка значений выборки в m = [log2 n] + 2 интервала:\n\n", n);
    
    % Вычисление m = [log2 n] + 2 промежутков
    m = floor(log2(n)) + 2;
    fprintf("Интервалов m = %3d\n\n", m);
    
    % Ширина интервала
    delta = (X(n) - X(1)) / m;
    
    % Поиск интервалов
    % Интервалы хранятся в виде матрицы m на 2
    intervals = zeros(m, 3);
    
    % Вычисление границ интервалов
    for ind = 1 : m - 1
        intervals(ind, 1) = X(1) + (ind - 1) * delta; 
        intervals(ind, 2) = X(1) + ind * delta;
    endfor
    
    % Вычисление границ интервалов для m
    intervals(m, 1) = X(1) + (m - 1) * delta; 
    intervals(m, 2) = X(n);
    
    % Вычисление кол-ва значений в интервалах
    indX = 1;
    indIntervals = 1;
    
    %% Задаются текущие границы интервала
    leftBorder = intervals(indIntervals, 1);
    rightBorder = intervals(indIntervals, 2);
    
    %% Цикл по всем элементам выборки
    while indX <= n
        
        %% Если элемент попал в границы, то инкремент для данного интервала
        if X(indX) >= leftBorder && X(indX) < rightBorder
            intervals(indIntervals, 3) = intervals(indIntervals, 3) + 1;
        %% Если элемент не попал в интервал
        else
            %% Элемент, не попавший в предыдущий интервал, должен быть
            %% обработан для следующего интервала
            indX -= 1;
            
            %% Для крайнего элемента выборки, который должен попасть в текущий интервал
            if indIntervals + 1 > m
                intervals(indIntervals, 3) = intervals(indIntervals, 3) + 1;
                break;
            endif
            
            %% Следующий интервал
            indIntervals = indIntervals + 1;
            
            %% Обновление границ текущего интервала
            leftBorder = rightBorder;
            rightBorder = intervals(indIntervals, 2);
            
        endif
        
        %% Следующий элемент выборки
        indX = indX + 1;
    endwhile
    
   % Вывести полученные интервалы
    for i = 1 : m
        if i == m
            fprintf("%3d. [ %3.4f ; %3.4f] : Элементов: %3d\n", i, 
                                                                intervals(i, 1), 
                                                                intervals(i, 2), 
                                                                intervals(i, 3));
        else
            fprintf("%3d. [ %3.4f ; %3.4f) : Элементов: %3d\n", i, 
                                                                intervals(i, 1), 
                                                                intervals(i, 2), 
                                                                intervals(i, 3));
        endif
    endfor
    
    
    % Задание 5
    fprintf("\n5) Построить гистограмму и график функции плотности \
             \n распределния вероятностей нормальной случайной величины с \
             \n математическим ожиданием mu и s_quad\n\n");   
            
    fprintf("Результат в отдельном окне\n");
    
    
    % Построение гистограммы
    
    gistData = zeros(m, 2);
    
    % Середины интервалов
    for ind = 1 : m
        gistData(ind, 1) = (intervals(ind, 1) + intervals(ind, 2)) / 2;
    endfor
    
    % Значения столбцов
    % k = ni / (n * delta)
    for ind = 1 : m
        gistData(ind, 2) = intervals(ind, 3) / (n * delta);
    endfor
    
    % График функции плотности распределения
    
    % Набор значений по X
    % начало:шаг:конец
    xGraph = (minX - 1):1e-3:(maxX + 1);
    
    sigma = sqrt(s_quad);
    % Значения функции плотности распределения
    % normpdf - функция плотности нормального распределения
    fNormal = normpdf(xGraph, mu, sigma);
    
    % Отрисовка графиков
    %% Отрисовка гистограммы
    bar(gistData(:, 1), gistData(:, 2), 1);
    
    %% Чтобы следующий график не стер предыдущий
    hold on;
    
    %% Отрисовка графика плоности нормального распределения 
    plot(xGraph, fNormal, 'r', 'LineWidth', 1.5);
    %% Сетка
    grid;
    
    
    % Задание 6
    fprintf("\n6) Построить график эмпирической функции распределения и\
             \n функции распределения нормальной случайной величины с \
             \n математическим ожиданием mu и s_quad\n\n");   
            
    fprintf("Результат в отдельном окне\n");
    
    % Набор значений для эмпирической функции распределния
    tSet = zeros(1, n + 2);
    
    
    tSet(1) = X(1) - 1;
    
    for ind = 2 : n + 1
        tSet(ind) = X(ind - 1);
    endfor
    
    tSet(n + 2) = X(n) + 1;
    
    % Значения эмпирической функции распреления
    nEmperic = length(tSet);
    Femperic = zeros(nEmperic, 1);
    
    for i = 1 : nEmperic
        cnt = 0;
        
        for j = 1: n
            % x(j - 1) < t <= x(j)
            if X(j) <= tSet(i)
                cnt = cnt + 1;
            endif
        endfor
        
        Femperic(i) = cnt / n;
    endfor
    
    
    % Набор значений по X
    % начало:шаг:конец
    xGraph = (minX - 1):1e-3:(maxX + 1);
    
    sigma = sqrt(s_quad);
    % Значения функции распределения
    % normpdf - функция нормального распределения
    Fnormal = normcdf(xGraph, mu, sigma);
    
    
    % Отрисовка графиков 
    %% Чтобы графики были в отдельном окне
    figure();
    %% Отрисовка эмпирической функции распределения
    stairs(tSet, Femperic);
    
    %% Чтобы следующий график не стер предыдущий
    hold on;
    
    %% Отрисовка графика нормального распределения 
    plot(xGraph, Fnormal, 'r', 'LineWidth', 1.5);
    %% Сетка
    grid;
endfunction
