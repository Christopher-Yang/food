% read text from train.json and store in "data"

fname = 'train.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
data = jsondecode(str);

%% extract cuisine types from data

% extract cuisine type of each recipe
Nentries = length(data); % total number of recipes in data
cuisine = cell(Nentries,1); % preallocate variable to store cuisine types
for i = 1:Nentries % loop over recipes
    cuisine{i} = data(i).cuisine;
end

% find number of recipes belonging to each cuisine type
cuisineTypes = unique(cuisine); % find all the unique types of cuisines
Ncuisines = length(cuisineTypes); % count number of unique cuisines
counts = NaN(Ncuisines,1); % preallocate variable to store counts
for i = 1:Ncuisines % loop to count number of recipes for each unique cuisine
    counts(i) = sum(strcmp(cuisineTypes{i},cuisine));
end

%% clean up ingredient list

rng(4); % random seed
Nrecipes = 100; % number of recipes to pull from each country

% array to store unique ingredients before and after editing
beforeList = []; % before editing
afterList = []; % after editing

% loop over each cuisine
for k = 1:Ncuisines
    
    idx = strcmp(cuisineTypes{k},cuisine); % find the index of recipes belonging to a particular cuisine
    region_data = data(idx); % extract the recipes for a single cuisine
        
    subset_data = datasample(region_data,Nrecipes,'replace',false); % select 100 random recipes from the cuisine
    
    for i = 1:length(subset_data)
        a = subset_data(i).ingredients;
        beforeList(i).(cuisineTypes{k}) = subset_data(i).ingredients; % store entries before editing
        
        % replace/remove some common symbols
        a = strrep(a, '_', ' '); % change all underscores to spaces
        a = strrep(a, '-', ' '); % change all hyphens to spaces
        a = strrep(a, ',', ''); % delete all commas
        a = strrep(a, '1% ', ''); % so on and so forth...
        a = strrep(a, '2% ', '');
        a = strrep(a, 'ç', 'c'); % these weird symbols are code for accent marks over letters
        a = strrep(a, 'è', 'e');
        a = strrep(a, 'î', 'i');
        a = strrep(a, 'é','e');
        a = strrep(a, 'â','a');
        a = strrep(a, '&', 'and');
            
        % remove/replace some common words
        a = strrep(a, 'boneless ', '');
        a = strrep(a, 'chile', 'chili');
        a = strrep(a, 'chilis', 'chili');
        a = strrep(a, 'chilies','chili');
        a = strrep(a, 'chillies','chili');
        a = strrep(a, 'chopped ', '');
        a = strrep(a, 'cooked ', '');
        a = strrep(a, 'cubed ', '');
        a = strrep(a, 'diced ', '');
        a = strrep(a, 'free range ','');
        a = strrep(a, 'fresh mozzarella', 'mozzarella cheese');
        a = strrep(a, 'fresh ', '');
        a = strrep(a, 'firmly packed ','');
        a = strrep(a, 'grated ', '');
        a = strrep(a, 'ground ', '');
        a = strrep(a, 'large ', '');
        a = strrep(a, 'less sodium','low sodium');
        a = strrep(a, 'lower sodium','low sodium');
        a = strrep(a, 'minced ', '');
        a = strrep(a, 'natural ','');
        a = strrep(a, 'non fat','nonfat');
        a = strrep(a, 'no salt added ','');
        a = strrep(a, 'organic ','');
        a = strrep(a, 'peeled ','');
        a = strrep(a, 'pitted ','');
        a = strrep(a, 'plain ','');
        a = strrep(a, 'prepared ','');
        a = strrep(a, 'reduced sodium','low sodium');
        a = strrep(a, 'reduced fat','low fat');
        a = strrep(a, 'regular ','');
        a = strrep(a, 'roasted ','');
        a = strrep(a, 'shredded ','');
        a = strrep(a, 'sliced ','');
        a = strrep(a, 'slivered ','');
        a = strrep(a, 'smoked ', '');
        a = strrep(a, 'small ','');
        a = strrep(a, 'skinless ','');
        a = strrep(a, 'store bought ','');
        a = strrep(a, 'strained ','');
        a = strrep(a, 'toasted ', '');
        a = strrep(a, 'uncooked ','');
        a = strrep(a, 'unflavored ','');
%         a = strrep(a, 'unsalted ','');
        a = strrep(a, 'unsmoked ','');
        a = strrep(a, 'unsweetened ','');
        
        % edit capitalized entries first
        a = strrep(a, '& dried fish', 'fish');
        a = strrep(a, 'Baileys Irish Cream Liqueur','Irish cream liqueur');
        a = strrep(a, 'Best Foods® Real Mayonnaise','mayonnaise');
        a = strrep(a, 'Challenge Butter','butter');
        a = strrep(a, 'Chinese egg noodles','egg noodles');
        a = strrep(a, 'Flora Cuisine','cooking oil');
        a = strrep(a, 'Foster Farms boneless chicken breasts','chicken breasts');
        a = strrep(a, 'Guinness Beer','beer');
        a = strrep(a, 'Heinz Tomato Ketchup','ketchup');
        a = strrep(a, 'Hellmann''s Light Mayonnaise','mayonnaise');
        a = strrep(a, 'Hogue Cabernet Sauvignon','cabernet sauvignon');
        a = strrep(a, 'Homemade yogurt','yogurt');
        a = strrep(a, 'Jell O Gelatin Dessert','Jell O');
        a = strrep(a, 'JOHNSONVILLE Hot & Spicy Sausage Slices','sausage');
        a = strrep(a, 'Jiffy Corn Muffin Mix','muffin mix');
        a = strrep(a, 'Jose Cuervo','tequila');
        a = strrep(a, 'KRAFT Zesty Italian Dressing','italian dressing');
        a = strrep(a, 'Kewpie Mayonnaise','mayonnaise');
        a = strrep(a, 'Kraft Miracle Whip Dressing','miracle whip');
        a = strrep(a, 'Kraft Slim Cut Mozzarella Cheese Slices','mozzarella cheese');
        a = strrep(a, 'Lipton® Recipe Secrets® Onion Soup Mix','onion soup mix');
        a = strrep(a, 'Louisiana Cajun Seasoning','cajun seasoning');
        a = strrep(a, 'Madeira','Madeira wine');
        a = strrep(a, 'Mexican cheese blend','Mexican cheese');
        a = strrep(a, 'Old El Paso�?� chopped green chiles','green chillies');
        a = strrep(a, 'Old El Paso�?� taco seasoning mix','taco seasoning mix');
        a = strrep(a, 'Oscar Mayer Cotto Salami','cotto salami');
        a = strrep(a, 'Oscar Mayer Deli Fresh Smoked Ham','ham');
        a = strrep(a, 'Ranch Style Beans','ranch style beans');
        a = strrep(a, 'Soy Vay® Veri Veri Teriyaki® Marinade & Sauce','teriyaki sauce');
        a = strrep(a, 'Spike Seasoning','Spike seasoning');
        a = strrep(a, 'Splenda Brown Sugar Blend','Splenda brown sugar blend');
        a = strrep(a, 'Swerve Sweetener','Swerve sweetener');
        a = strrep(a, 'Tokyo negi','negi');
        a = strrep(a, 'Wish Bone Light Italian Dressing','italian dressing');
        a = strrep(a, 'Zatarain�??s Jambalaya Mix','jambalaya mix');
        
        % edit all other entries
        a = strrep(a, 'active dry yeast','dry yeast');
        a = strrep(a, 'all potato purpos','potatoes');
        a = strrep(a, 'angel hair','angel hair pasta');
        a = strrep(a, 'artichok heart marin','artichoke hearts');
        a = strrep(a, 'asian fish sauce','fish sauce');
        a = strrep(a, 'asian wheat noodles','wheat noodles');
        a = strrep(a, 'asparagus spears','asparagus');
        a = strrep(a, 'baby back ribs','pork baby back ribs');
        a = strrep(a, 'baby spinach leaves','baby spinach');
        a = strrep(a, 'bacon slices','bacon');
        a = strrep(a, 'barbecued pork','pork');
        a = strrep(a, 'barramundi fillets','barramundi');
        a = strrep(a, 'basil leaves','basil');
        a = strrep(a, 'bay leaf','bay leaves');
        a = strrep(a, 'bbq sauce','barbecue sauce');
        a = strrep(a, 'beansprouts','bean sprouts');
        a = strrep(a, 'beaten eggs','egg');
        a = strrep(a, 'beef bouillon granules','beef bouillon');
        a = strrep(a, 'beef for stew','beef');
        a = strrep(a, 'bittersweet chocolate chips','bittersweet chocolate');
        a = strrep(a, 'black peppercorns','black pepper');
        a = strrep(a, 'blanched almonds','almonds');
        a = strrep(a, 'blanco cheese queso','queso blanco');
        a = strrep(a, 'boiling potatoes','potatoes');
        a = strrep(a, 'boiling water','water');
        a = strrep(a, 'bone in chicken thighs','chicken thighs');
        a = strrep(a, 'bone in skin on chicken thigh','chicken thighs');
        a = strrep(a, 'bone in chicken breast halves','chicken breasts');
        a = strrep(a, 'bone in pork chops','pork chops');
        a = strrep(a, 'bottom round','beef bottom round');
        a = strrep(a, 'center cut pork chops','pork chops');
        a = strrep(a, 'chicken breast','chicken breasts');
        a = strrep(a, 'chicken breast halves','chicken breasts');
        a = strrep(a, 'chop pork','pork chops');
        a = strrep(a, 'pork loin','pork loin');
        a = strrep(a, 'chicken breast halves','chicken breasts');
        a = strrep(a, 'chicken breast','chicken breasts');
        a = strrep(a, 'bread crumb fresh','bread crumbs');
        a = strrep(a, 'brine cured green olives','green olives');
        a = strrep(a, 'brine cured black olives','black olives');
        a = strrep(a, 'butterflied leg of lab','leg of lamb');
        a = strrep(a, 'bénédictine','benedictine');
        a = strrep(a, 'cajun seasoning mix','cajun seasoning');
        a = strrep(a, 'cajun creole seasoning mix','cajun seasoning');
        a = strrep(a, 'candied bacon','bacon');
        a = strrep(a, 'canned beef broth','beef broth');
        a = strrep(a, 'canned black beans','black beans');
        a = strrep(a, 'canned coconut milk','coconut milk');
        a = strrep(a, 'canned low sodium chicken broth','low sodium chicken broth');
        a = strrep(a, 'capicollo','capicola');
        a = strrep(a, 'cardamom pods','caradmom');
        a = strrep(a, 'caribbean jerk seasoning','jerk seasoning');
        a = strrep(a, 'catfish fillets','catfish');
        a = strrep(a, 'catsup','ketchup');
        a = strrep(a, 'cauliflower florets','cauliflower');
        a = strrep(a, 'celery stick','celery');
        a = strrep(a, 'celery ribs','celery');
        a = strrep(a, 'center cut bacon','bacon');
        a = strrep(a, 'center cur loin pork chop','pork chops');
        a = strrep(a, 'chees fresh mozzarella','mozzarella cheese');
        a = strrep(a, 'chicken breast halves','chicken breasts');
        a = strrep(a, 'chicken breast tenders','chicken breasts');
        a = strrep(a, 'chicken meat','chicken');
        a = strrep(a, 'chicken parts','chicken pieces');
        a = strrep(a, 'chicken thigh fillets','chicken thighs');
        a = strrep(a, 'chilli paste','chili paste');
        a = strrep(a, 'chillies','chili');
        a = strrep(a, 'chocolate bars','chocolate');
        a = strrep(a, 'chop fine pecan','pecans');
        a = strrep(a, 'chorizo sausage','chorizo');
        a = strrep(a, 'cilantro fresh','cilantro');
        a = strrep(a, 'chuck','beef chuck roast');
        a = strrep(a, 'chuck roast','beef chuck roast');
        a = strrep(a, 'chuck steaks','beef chuck steaks');
        a = strrep(a, 'chuck tender','beef chuck tender');
        a = strrep(a, 'fresh mint','mint');
        a = strrep(a, 'cilantro leaves','cilantro');
        a = strrep(a, 'cilantro root','cilantro');
        a = strrep(a, 'cilantro sprigs','cilantro');
        a = strrep(a, 'cilantro stems','cilantro');
        a = strrep(a, 'cinnamon sticks','cinnamon');
        a = strrep(a, 'clove garlic, fine chop','garlic');
        a = strrep(a, 'coarse kosher salt','kosher salt');
        a = strrep(a, 'coarse salt','salt');
        a = strrep(a, 'coarse sea salt','sea salt');
%         a = strrep(a, 'cocoa powder','cocoa');
        a = strrep(a, 'cold water','water');
        a = strrep(a, 'color food green','food coloring');
        a = strrep(a, 'color food orang','food coloring');
        a = strrep(a, 'confit duck leg','duck leg');
        a = strrep(a, 'corn kernel whole','corn kernels');
        a = strrep(a, 'crab boil','crab');
        a = strrep(a, 'crab meat','crab');
        a = strrep(a, 'crabmeat','crab');
        a = strrep(a, 'cracked black pepper','black pepper');
        a = strrep(a, 'cream cheese, soften','cream cheese');
        a = strrep(a, 'creole seasoning mix','creole seasoning');
        a = strrep(a, 'crushed garlic','garlic');
        a = strrep(a, 'crushed ice','ice');
        a = strrep(a, 'crushed red pepper','crushed red pepper flakes');
        a = strrep(a, 'deveined shrimp','shrimp');
        a = strrep(a, 'dijon style mustard','dijon mustard');
        a = strrep(a, 'dri leav thym','dried thyme');
        a = strrep(a, 'dri oregano leaves, crush','dried oregano');
        a = strrep(a, 'dried soba','soba');
        a = strrep(a, 'dry roasted peanuts','peanuts');
        a = strrep(a, 'duck breast halves','duck breasts');
        a = strrep(a, 'e fu noodl','e fu noodles');
        a = strrep(a, 'eggs', 'egg');
        a = strrep(a, 'egg noodles, cooked and drained','egg noodles');
        a = strrep(a, 'egg roll wraps','egg roll wrappers');
        a = strrep(a, 'eggroll wrappers','egg roll wrappers');
        a = strrep(a, 'extra large eggs','egg');
        a = strrep(a, 'extra large shrimp','shrimp');
        a = strrep(a, 'fajita seasoning mix','fajita seasoning');
        a = strrep(a, 'fajita size flour tortillas','flour tortillas');
        a = strrep(a, 'fat trimmed beef flank steak','beef flank steak');
        a = strrep(a, 'fatfree lowsodium chicken broth','chicken broth');
        a = strrep(a, 'fast rising active dry yeast','dry yeast');
        a = strrep(a, 'feta cheese crumbles','feta cheese');
        a = strrep(a, 'fettuccine pasta','fettuccine');
        a = strrep(a, 'fettuccine, cook and drain','fettuccine');
        a = strrep(a, 'fillet red snapper','red snapper');
        a = strrep(a, 'fine sea salt','sea salt');
        a = strrep(a, 'finely fresh parsley','parlsey');
        a = strrep(a, 'finely onion','onion');
        a = strrep(a, 'five spice powder','five spice');
        a = strrep(a, 'flank steak','beef flank steak');
        a = strrep(a, 'flounder fillets','flounder');
        a = strrep(a, 'flour for dusting','flour');
        a = strrep(a, 'food colouring','food coloring');
        a = strrep(a, 'freshly grated parmesan', 'parmesan cheese');
        a = strrep(a, 'freshly pepper','black pepper');
        a = strrep(a, 'garlic cloves','garlic');
        a = strrep(a, 'gingerroot', 'ginger root');
        a = strrep(a, 'grate lime peel','lime peel');
        a = strrep(a, 'grating cheese','cheese');
        a = strrep(a, 'green bell pepper, slice','green bell pepper');
        a = strrep(a, 'green cardamom pods','green cardamom');
        a = strrep(a, 'green tea bags','green tea');
        a = strrep(a, 'guajillo chiles','guajillo');
        a = strrep(a, 'gyoza wrappers','dumpling wrappers');
        a = strrep(a, 'habanero pepper','habanero');
        a = strrep(a, 'hard boiled egg','egg');
        a = strrep(a, 'ice cubes','ice');
        a = strrep(a, 'ice water','water');
        a = strrep(a, 'icing mix','icing');
        a = strrep(a, 'kochu chang','gochujang');
        a = strrep(a, 'kochujang','gochujang');
        a = strrep(a, 'korean chile paste','gochujang');
        a = strrep(a, 'leav spinach', 'spinach');
        a = strrep(a, 'lemon grass','lemongrass');
        a = strrep(a, 'lettuce leaves','lettuce');
        a = strrep(a, 'loin pork roast','pork loin roast');
        a = strrep(a, 'low salt chicken broth','low sodium chicken broth');
        a = strrep(a, 'lowfat greekstyl yogurt','low fat greek yogurt');
        a = strrep(a, 'luke warm water','water');
        a = strrep(a, 'lump crab meat','crab');
        a = strrep(a, 'lumpia skins','lumpia wrappers');
        a = strrep(a, 'mayonaise','mayonnaise');
        a = strrep(a, 'medium eggs','egg');
        a = strrep(a, 'medium shrimp','shrimp');
        a = strrep(a, 'medium shrimp uncook','shrimp');
        a = strrep(a, 'melted butter','butter');
        a = strrep(a, 'melted fat','fat');
        a = strrep(a, 'mini chocolate chips','chocolate chips');
        a = strrep(a, 'mini phyllo dough shells','phyllo dough shells');
        a = strrep(a, 'mint sprigs','mint');
        a = strrep(a, 'miso paste','miso');
        a = strrep(a, 'monterey jack','monterey jack cheese');
        a = strrep(a, 'mung bean sprouts','bean sprouts');
        a = strrep(a, 'mussels, well scrubbed','mussels');
        a = strrep(a, 'napa cabbage leaves','napa cabbage');
        a = strrep(a, 'nappa cabbage','napa cabbage');
        a = strrep(a, 'nonfat dried milk','nonfat dry milk');
        a = strrep(a, 'olive oil flavored cooking spray','olive oil cooking spray');
        a = strrep(a, 'oregano leaves', 'oregano');
        a = strrep(a, 'pak choi','bok choy');
        a = strrep(a, 'panko breadcrumbs','panko');
        a = strrep(a, 'parmigiana reggiano','parmigiano reggiano cheese');
        a = strrep(a, 'parsley leaves','parsley');
        a = strrep(a, 'parsley sprigs','parsley');
        a = strrep(a, 'pecan halves','pecans');
        a = strrep(a, 'penne pasta','penne');
        a = strrep(a, 'phyllo dough','phyllo');
        a = strrep(a, 'phyllo pastry','phyllo');
        a = strrep(a, 'pineapple chunks','pineapple');
        a = strrep(a, 'pita bread rounds','pita bread');
        a = strrep(a, 'pitas','pita bread');
        a = strrep(a, 'pork chops, 1 inch thick','pork chops');
        a = strrep(a, 'pork shoulder roast','pork shoulder');
        a = strrep(a, 'prepar salsa','salsa');
        a = strrep(a, 'pure acai puree','acai puree');
        a = strrep(a, 'pure maple syrup','maple syrup');
        a = strrep(a, 'pure olive oil','olive oil');
        a = strrep(a, 'pure vanilla extract','vanilla extract');
        a = strrep(a, 'quick cooking brown rice','brown rice');
        a = strrep(a, 'quick cooking oats','oats');
        a = strrep(a, 'quickcooking grits','grits');
        a = strrep(a, 'red kidnei beans, rins and drain','red kidney beans');
        a = strrep(a, 'rib eye steaks','beef rib eye steaks');
        a = strrep(a, 'roast red peppers, drain','red pepper');
        a = strrep(a, 'red peppers','red pepper');
        a = strrep(a, 'salmon fillets','salmon');
        a = strrep(a, 'salted butter','butter');
        a = strrep(a, 'salted cashews','cashews');
        a = strrep(a, 'salted fish','fish');
        a = strrep(a, 'salted peanuts','peanuts');
        a = strrep(a, 'salted roast peanuts','peanuts');
        a = strrep(a, 'sandwich bread','bread');
        a = strrep(a, 'sandwich buns','buns');
        a = strrep(a, 'scallion greens','scallions');
        a = strrep(a, 'sea bass fillets','sea bass');
        a = strrep(a, 'sea salt flakes','sea salt');
        a = strrep(a, 'seasoning salt','salt');
        a = strrep(a, 'semi sweet chocolate morsels','semisweet chocolate');
        a = strrep(a, 'semolina flour','semolina');
        a = strrep(a, 'shell on shrimp','shrimp');
        a = strrep(a, 'shiromiso','shiro miso');
        a = strrep(a, 'shuck corn','corn');
        a = strrep(a, 'shucked oysters','oysters');
        a = strrep(a, 'slaw mix','slaw');
        a = strrep(a, 'soba noodles','soba');
        a = strrep(a, 'sodium reduced beef broth','beef broth');
        a = strrep(a, 'soft boiled egg','egg');
        a = strrep(a, 'softened butter','butter');
        a = strrep(a, 'sole fillet','sole');
        a = strrep(a, 'sourdough loaf','sourdough bread');
        a = strrep(a, 'soybean sprouts','bean sprouts');
        a = strrep(a, 'spinach leaves','spinach');
        a = strrep(a, 'splenda no calorie sweetener','splenda');
        a = strrep(a, 'spring onions','scallions');
        a = strrep(a, 'steamed rice','rice');
        a = strrep(a, 'steamed white rice','white rice');
        a = strrep(a, 'sugar cane','sugarcane');
        a = strrep(a, 'sun dried tomatoes in oil','sun dried tomatoes');
        a = strrep(a, 'taco seasoning mix','taco seasoning');
        a = strrep(a, 'tahini paste','tahini');
        a = strrep(a, 'tea bags','tea leaves');
        a = strrep(a, 'thick cut bacon','bacon');
        a = strrep(a, 'thyme leaves','thyme');
        a = strrep(a, 'thyme sprigs','thyme');
        a = strrep(a, 'tilapia fillets','tilapia');
        a = strrep(a, 'tomatoes with juice','tomatoes');
        a = strrep(a, 'trout fillet','trout');
        a = strrep(a, 'tuna in oil','tuna');
        a = strrep(a, 'tuna packed in olive oil','tuna');
        a = strrep(a, 'tuna packed in water','tuna');
        a = strrep(a, 'tuna steaks','tuna');
        a = strrep(a, 'vegetable oil cooking spray','vegetable oil spray');
        a = strrep(a, 'veggies','vegetables');
        a = strrep(a, 'vermicelli noodles','vermicelli');
        a = strrep(a, 'vietnamese fish sauce','fish sauce');
        a = strrep(a, 'vine ripened tomatoes','tomatoes');
        a = strrep(a, 'vine tomatoes','tomatoes');
        a = strrep(a, 'walnut halves','walnuts');
        a = strrep(a, 'warm water','water');
        a = strrep(a, 'wasabi paste','wasabi');
        a = strrep(a, 'water packed artichoke hearts','artichoke hearts');
        a = strrep(a, 'whipped cream','heavy cream');
        a = strrep(a, 'whipped topping','heavy cream');
        a = strrep(a, 'whitefish fillets','whitefish');
        a = strrep(a, 'whole allspice','allspice');
        a = strrep(a, 'whole almonds','almonds');
        a = strrep(a, 'whole chicken','chicken');
        a = strrep(a, 'whole cloves','clove');
        a = strrep(a, 'whole nutmegs','nutmeg');
        a = strrep(a, 'whole peeled tomatoes','tomatoes');
        a = strrep(a, 'whole peppercorn','peppercorn');
        a = strrep(a, 'whole snapper','snapper');
        a = strrep(a, 'won ton wrappers','wonton wrappers');
        a = strrep(a, 'yoghurt','yogurt');
        a = strrep(a, 'yogurt low fat','yogurt');
        
        % finally, replace all spaces with underscores so Gephi can read
        % these strings
        a = strrep(a, ' ', '_');
        
        subset_data(i).ingredients = a; % replace original entry with edited entry
        afterList(i).(cuisineTypes{k}) = subset_data(i).ingredients; % store edited entry
    end
    
    count = 1; % counter for storing data
    ings = {};
    
    % loop over the 100 random recipes
    for i = 1:length(subset_data)
        a = subset_data(i).ingredients; % placeholder variable for ease of access

        n = length(a); % total number of ingredients in recipe i
        for j = 1:n % loop over ingredients in recipe
            ings{count-1+j} = a{j}; % store each ingredient as a separate entry in ings
        end

        count = count+n; % increment index based on number of ingredients
    end
    
    % build adjacency matrices for each cuisine
    names{k} = unique(ings);
    adjMatrix{k} = zeros(length(names{k}));
    
    for i = 1:Nrecipes
        combos = nchoosek(subset_data(i).ingredients,2);
        
        for j = 1:size(combos,1)
            a = combos(j,:);
            rowIdx = strcmp(a(1),names{k});
            columnIdx = strcmp(a(2),names{k});
            
            adjMatrix{k}(rowIdx,columnIdx) = adjMatrix{k}(rowIdx,columnIdx) + 1;
            adjMatrix{k}(columnIdx,rowIdx) = adjMatrix{k}(columnIdx,rowIdx) + 1;
        end
    end
end

% determine whether there are self-loops in the adjacency matrix; we want
% to eliminate all self-loops because an ingredient should not be connected
% to itself; self_loops{k} contains the self loops for the kth country in
% cuisineTypes
for k = 1:Ncuisines
    idx = diag(adjMatrix{k}) > 0; % indices of self-loops
    if sum(idx) > 0 % if there are self loops...
        self_loops{k} = names{k}(idx); % store names of ingredients which have self loops
    else % if there are no self loops...
        self_loops{k} = ''; % store nothing in this index
    end
end

%% plot adjacency matrices

country = 1;

G = graph(adjMatrix{country});
D = degree(G);

figure(3); clf
% plot(G,'NodeLabel',names{country},'MarkerSize',D)
% plot(G,'NodeLabel',names{country})
plot(G)