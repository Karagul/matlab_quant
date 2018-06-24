%Getting started with portfolio optimization
%Portfolio optimization 

T=readtable('dowPortfolio.xlsx')

symbol = T.Properties.VariableNames(3:end)';
dailyReturn = tick2ret(T{:,3:end});
p = Portfolio('AssetList',symbol,'RiskFreeRate',0.01/252);
p = estimateAssetMoments(p, dailyReturn);
p = setDefaultConstraints(p); 
w1 = estimateMaxSharpeRatio(p)

[risk1, ret1] = estimatePortMoments(p, w1)

%Data visualization
%plot the risk and expected return of all asset in the portfolio
f = figure;
tabgp = uitabgroup(f); %define tab group
tab1 = uitab(tabgp,'Title','Efficient Frontier Plot'); % Create tab
ax = axes('Parent', tab1);
% Extract asset moments from portfolio and store in m and cov
[m, cov] = getAssetMoments(p); 
scatter(ax,sqrt(diag(cov)), m,'oc','filled'); % Plot mean and s.d.
xlabel('Risk')
ylabel('Expected Return')
text(sqrt(diag(cov))+0.0003,m,symbol,'FontSize',7); % Label ticker names

%plot optimal portfolio and efficient frontier using plotFinder
hold on;
[risk2, ret2]  = plotFrontier(p,10);
plot(risk1,ret1,'p','markers',15,'MarkerEdgeColor','k',...
                'MarkerFaceColor','y');
hold off

%visualize table in MATLAB
tab2 = uitab(tabgp,'Title','Optimal Portfolio Weight'); % Create tab
% Column names and column format
columnname = {'Ticker','Weight (%)'};
columnformat = {'char','numeric'};
% Define the data as a cell array
data = table2cell(table(symbol(w1>0),w1(w1>0)*100));
% Create the uitable
uit = uitable(tab2, 'Data', data,... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'RowName',[]);
% Set width and height
uit.Position(3) = 450; % Widght
uit.Position(4) = 350; % Height