newMat = [1 1 1 1 0 0 0 0
           1 0 1 1 0 0 0 0
           1 1 0 1 0 0 0 0
           1 1 1 0 1 0 0 0
           0 0 0 1 0 1 1 1
           0 0 0 0 1 0 1 1
           0 0 0 0 1 1 0 1
           0 0 0 0 1 1 1 0];

% newMat = adjMatrix;

% G = graph(newMat);
% figure(1); clf
% plot(G);


run_loop = true;
Nrun = 1;
classOrder = {};
while run_loop
    
    n = size(newMat,1);
    classes = cell(size(newMat,1),1);
    
    for i = 1:n
        classes{i} = NaN(1,n);
        classes{i}(1) = i;
    end
    
    eval_modularity = true;
    while eval_modularity
        count = 0;
        
        for i = 1:n
            a = newMat(i,:);
            idx = find(a>0);
            idx = idx(idx ~= i);
            Q = [];
            
            for j = 1:length(idx)
                a = cellfun(@(x) find(x==idx(j)), classes, 'UniformOutput', false);
                g = find(cellfun(@(x) ~isempty(x),a));
                
                C = sort(classes{g}(~isnan(classes{g})));
                
                sum_in = calc_sum_in(newMat,i,C);
                sum_tot = calc_sum_tot(newMat,i,C);
                
                k_i = sum(newMat(:,i));
                k_in = newMat(i,i) + sum(newMat(i,C));
                m = (sum(sum(newMat)) + sum(diag(newMat)))/2;
                
                Q(j) = (((sum_in + 2*k_in)/(2*m)) - ((sum_tot + k_i)/(2*m))^2) - ...
                    ((sum_in/(2*m)) - (sum_tot/(2*m))^2 - (k_i/(2*m))^2);
            end
            
            [value, k] = max(Q);
            
            a = cellfun(@(x) find(x==idx(k)), classes, 'UniformOutput', false);
            group_target = find(cellfun(@(x) ~isempty(x),a));
            
            a = cellfun(@(x) find(x==i), classes, 'UniformOutput', false);
            group_source = find(cellfun(@(x) ~isempty(x),a));
            
            if value > 0 && group_target ~= group_source
                idx2 = find(isnan(classes{group_target}),1);
                classes{group_target}(idx2) = i;
                
                idx2 = find(classes{group_source} == i);
                classes{group_source}(idx2) = NaN;
                
                if sum(~isnan(classes{group_source})) == 0
                    classes(group_source) = [];
                end
                
                count = count + 1;
            end
        end
        
        if count == 0
            eval_modularity = false;
            
            for i = 1:length(classes)
                classes{i} = sort(classes{i}(~isnan(classes{i})));
            end
        end
    end
    
    Nclasses = length(classes);
    oldMat = newMat;
    newMat = zeros(Nclasses);
    diagonal = diag(oldMat);
    for i = 1:Nclasses
        a = classes{i};
        pairs = nchoosek(a,2);
        self_loops = 0;
        
        for j = 1:size(pairs,1)
            self_loops = self_loops + oldMat(pairs(j,1), pairs(j,2));
        end
        
        self_loops = self_loops + sum(diagonal(a));
        newMat(i,i) = self_loops;
    end
    
    classPairs = nchoosek(1:Nclasses,2);
    Npairs = size(classPairs,1);
    for i = 1:Npairs
        c1 = classes{classPairs(i,1)};
        c2 = classes{classPairs(i,2)};
        
        [A,B] = meshgrid(c1,c2);
        c=cat(2,A',B');
        c=reshape(c,[],2);
        edges = 0;
        
        for j = 1:size(c,1)
            edges = edges + oldMat(c(j,1), c(j,2));
        end
        
        newMat(classPairs(i,1), classPairs(i,2)) = edges;
    end
    
    newMat = triu(newMat) + tril(newMat',-1);
    
    classOrder{Nrun} = classes;
    Nrun = Nrun + 1;
    
    if size(newMat) == size(oldMat)
        if sum(sum(newMat == oldMat)) == numel(newMat)
            run_loop = false;
        end
    end
end

function output = calc_sum_in(newMat,i,C)
    self_loops_C = 0;
    for j = 1:length(C)
        self_loops_C = self_loops_C + newMat(C(j),C(j));
    end
    output = self_loops_C + newMat(i,i) + sum(newMat(i,C));
end

function output = calc_sum_tot(newMat,i,C)
    idx = unique(sort([i C]));
    pairs = nchoosek(idx,2);
    repeats = 0;
    
    for j = 1:size(pairs,1)
        repeats = repeats + newMat(pairs(j,1), pairs(j,2));
    end
    output = sum(sum(newMat(:,idx))) - repeats;
end