% read text from train.json and store in "data"

fname = 'train.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
data = jsondecode(str);

%% extract cuisine types from data

Nentries = length(data); % total number of recipes in data
cuisine = cell(Nentries,1); % preallocate variable to store cuisine types
for i = 1:Nentries % loop over recipes
    cuisine{i} = data(i).cuisine;
end

cuisineTypes = unique(cuisine); % find all the unique types of cuisines
Ncuisines = length(cuisineTypes); % count number of unique cuisines
counts = NaN(Ncuisines,1); % preallocate variable to store counts
for i = 1:Ncuisines % loop to count number of recipes for each unique cuisine
    counts(i) = sum(strcmp(cuisineTypes{i},cuisine));
end

%%
rng(3);
Nsamples = 15;
ingredients2 = cell(1,1);
count = 1; % counter for determining where to store ingredient data

regions = {'brazilian','irish','vietnamese','moroccan','cajun_creole'};
Nregions = length(regions);
clear subset_data

for k = 1:length(regions)
    idx = strcmp(regions{k},cuisine);
    region_data = data(idx);
    
    idx2 = (k-1)*Nsamples+1:(k-1)*Nsamples+Nsamples;
    
    subset_data(idx2,1) = datasample(region_data,Nsamples,'replace',false);
end

for i = 1:length(subset_data)
    a = subset_data(i).ingredients;
    for j = 1:length(a)
        a = strrep(a, ' ', '_');
        a = strrep(a, '-', '_');
        a = strrep(a, '2%_', '');
        a = strrep(a, 'ç', 'c');
        a = strrep(a, ',_soften', '');
        a = strrep(a, ',_thawed_and_squeezed_dry', '');
        a = strrep(a, '&', 'and');
    end
    
    subset_data(i).ingredients = a;
% end
% 
% for i = 1:length(subset_data) % loop over recipes
%     a = subset_data(i).ingredients; % store cuisine in temporary variable "a"
    n = length(a); % total number of ingredients in recipe i
    for j = 1:n % loop over ingredients in recipe
        ingredients2{count-1+j} = a{j};
    end
    
    count = count+n; % increment index based on number of ingredients
end

names = unique(ingredients2);

adjMatrix = zeros(length(names));

for i = 1:length(regions)*Nsamples
    combos = nchoosek(subset_data(i).ingredients,2);
    
    for j = 1:size(combos,1)
        a = combos(j,:);
        rowIdx = strcmp(a(1),names);
        columnIdx = strcmp(a(2),names);
        
        adjMatrix(rowIdx,columnIdx) = adjMatrix(rowIdx,columnIdx) + 1;
        adjMatrix(columnIdx,rowIdx) = adjMatrix(columnIdx,rowIdx) + 1;
    end
    
end

Ningredients = length(names);
fiedler = NaN(Ningredients,1);

for i = 1:Ningredients
    if i == 1
        subset_mat = adjMatrix(2:end, 2:end);
    elseif i == Ningredients
        subset_mat = adjMatrix(1:end-1, 1:end-1);
    else
        subset_mat = [adjMatrix(1:i-1, 1:i-1) adjMatrix(1:i-1, i+1:end)
                      adjMatrix(i+1:end, 1:i-1) adjMatrix(i+1:end, i+1:end)];
    end
    
    G = graph(subset_mat);
    L = laplacian(G);
    e = eig(L);
    fiedler(i) = e(2);
end

critical_ingredients = names(fiedler <= 0);

% G = graph(adjMatrix);
% D = degree(G);
% figure(3); clf
% plot(G,'NodeLabel',names,'MarkerSize',D)

%%

T1 = array2table(adjMatrix);
T1.Properties.VariableNames = names;

T2 = table(names', 'VariableNames', {'header'});

T = [T2 T1];

writetable(T, '../../Gephi/test.csv')
%% extract ingredients from data

ingredients = cell(428275,1); % preallocate variable; there are 428275 total ingredients in the train.json
cuisineIdx = cell(428275,1);
idx = 1; % counter for determining where to store ingredient data
for i = 1:Nentries % loop over recipes
    a = data(i).ingredients; % store cuisine in temporary variable "a"
    n = length(a); % total number of ingredients in recipe i
    for j = 1:n % loop over ingredients in recipe
        ingredients{idx-1+j} = a{j};
        cuisineIdx{idx-1+j} = cuisine{i};
    end
    
    idx = idx+n; % increment index based on number of ingredients
end

idx = strcmp('mexican',cuisineIdx);
mexican = ingredients(idx);

%%
ingredientTypes = unique(ingredients); % count number of unique ingredients
Ningredients = length(ingredientTypes); % total number of unique ingredients
ingCounts = NaN(Ningredients,1); % preallocate variable
for i = 1:Ningredients % loop over unique ingredients to count total number of that ingredient
    ingCounts(i) = sum(strcmp(ingredientTypes{i},ingredients));
end
%% plot data

% plots counts of cuisine types
figure(1); clf; hold on
bar(categorical(cuisineTypes),counts)
title('Cuisine types')
ylabel('counts')

% plot counts of the top n ingredients; n can be changed to desired value
n = 20;
[ings, idx] = maxk(ingCounts,n);

figure(2); clf; hold on
bar(categorical(ingredientTypes(idx)),ings)
title([num2str(n) ' most common ingredients'])
ylabel('counts')
