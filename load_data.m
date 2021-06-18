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

%% extract ingredients from data

ingredients = cell(428275,1); % preallocate variable; there are 428275 total ingredients in the train.json
idx = 1; % counter for determining where to store ingredient data
for i = 1:Nentries % loop over recipes
    a = data(i).ingredients; % store cuisine in temporary variable "a"
    n = length(a); % total number of ingredients in recipe i
    for j = 1:n % loop over ingredients in recipe
        ingredients{idx-1+j} = a{j};
    end
    idx = idx+n; % increment index based on number of ingredients
end

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
