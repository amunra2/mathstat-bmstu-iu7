function lab_02()
    X = csvread('data21.csv');
    
    % Оценки мат ожидания и дисперсии
    mu = CalcMu(X);
    fprintf("\nВыборочное среднее (оценка мат ожидания) = %.4f\n", mu);
    
    s2 = CalcS2(X);
    fprintf("Исправленная выборочная дисперсия (оценка дисперсии) = %.4f\n", s2);
    
    % Гамма
    gamma = 0.9;
    N = length(X);
    
    % Вычисление доверительных интервалов
    [lowM, highM] = CalcIntervalM(mu, s2, gamma, N);
    fprintf("\nИнтервал для M: (%.4f, %.4f)\n", lowM, highM);
    
    [lowD, highD] = CalcIntervalD(s2, gamma, N);
    fprintf("Интервал для D: (%.4f, %.4f)\n", lowD, highD);
    
    % Построение графиков
    graphMu(X, gamma, N);
    graphS2(X, gamma, N);
endfunction


function graphS2(X, gamma, N)
    figure()
    
    mu = zeros(N, 1);
    s2 = zeros(N, 1);
    
    for ind = 1 : N
        part = X(1:ind);
        mu(ind) = CalcMu(part);
        s2(ind) = CalcS2(part);
    endfor
    
    % Прямая
    s2Line = zeros(N, 1);
    s2Line(1:N) = s2(N);
    
    % Для границ
    s2Low =  zeros(N, 1);
    s2High = zeros(N, 1);
    
    for ind = 1 : N
        [s2Low(ind), s2High(ind)] = CalcIntervalD(s2(ind), gamma, ind);   
    endfor
    
    % Графики
    plot((5:N), s2Line(5:N), 'g', 'LineWidth', 1);
    hold on;
    plot((5:N), s2(5:N), 'b-', 'LineWidth', 1);
    hold on;
    plot((5:N), s2High(5:N), 'r--', 'LineWidth', 1);
    hold on;
    plot((5:N), s2Low(5:N), 'k', 'LineWidth', 1);
    hold on;
    
    grid on;
    xlabel("n");
    ylabel("\sigma");
    
    legend('S^2(x_N)', 'S^2(x_n)', '\sigma^{2 up}(x_n)', '\sigma^2_{down}(x_n)');
endfunction


function graphMu(X, gamma, N)
    mu = zeros(N, 1);
    s2 = zeros(N, 1);
    
    for ind = 1 : N
        part = X(1:ind);
        mu(ind) = CalcMu(part);
        s2(ind) = CalcS2(part);
    endfor
    
    % Прямая
    muLine = zeros(N, 1);
    muLine(1:N) = mu(N);
    
    % Для границ
    muLow =  zeros(N, 1);
    muHigh = zeros(N, 1);
    
    for ind = 1 : N
        [muLow(ind), muHigh(ind)] = CalcIntervalM(mu(ind), s2(ind), gamma, ind);   
    endfor
    
    % Графики
    plot((1:N), muLine(1:N), 'g', 'LineWidth', 1);
    hold on;
    plot((1:N), mu(1:N), 'b-', 'LineWidth', 1);
    hold on;
    plot((1:N), muHigh(1:N), 'r--', 'LineWidth', 1);
    hold on;
    plot((1:N), muLow(1:N), 'k', 'LineWidth', 1);
    hold on;
    
    grid on;
    xlabel("n");
    ylabel("\mu");
    
    legend('\mu\^(x_N)', '\mu\^(x_n)', '\mu^{up}(x_n)', '\mu_{down}(x_n)');
endfunction


% Доверительный интервал при
% m - неизвестно, sigma - неизвестно
% Оценить m
function [lowM, highM] = CalcIntervalM(mu, s2, gamma, N)
    alpha = (1 - gamma) / 2;
    quantileStudent = tinv((1 - alpha), (N - 1));
    
    lowM =  mu - (quantileStudent * sqrt(s2) / sqrt(N));
    highM = mu + (quantileStudent * sqrt(s2) / sqrt(N));
endfunction


% Доверительный интервал при
% sigma - неизвестно
% Оценить sigma^2
function [lowD, highD] = CalcIntervalD(s2, gamma, N)
    alpha = (1 - gamma) / 2;
    
    quantileXi2Low =  chi2inv((1 - alpha), (N - 1));
    quantileXi2High = chi2inv(alpha, (N - 1));
    
    lowD =  s2 * (N - 1) / quantileXi2Low;
    highD = s2 * (N - 1) / quantileXi2High;
endfunction


% Вычисление выборочного среднего
function mu = CalcMu(X)
    n = length(X);
    
    mu = sum(X) / n;
endfunction


% Вычисление исправленной выборочной дисперсии
function s2 = CalcS2(X)
    n = length(X);
    mu = CalcMu(X);
    
    if (n > 1)
        s2 = sum((X - mu) .^2) / (n - 1);
    else
        s2 = 0;
    endif
    
endfunction
