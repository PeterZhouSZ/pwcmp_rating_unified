clear all

params.dataset_sizes = [10,14];
params.rating_per_ds = [10,10];
params.numb_cross_ds_pairs = [20];
params.numb_comps_per_cross_ds_pair = [10];
n_exps = 10;

% Generate true quality scores
Q_true = sort(rand(1,params.dataset_sizes(1)));
Q_true(1) = 0;
for dataset=params.dataset_sizes(2:end)
    q_true_ds_ii = sort(rand(1,dataset));
    Q_true = [Q_true,q_true_ds_ii];
end

RMSE = 0;
for ii =1:n_exps
    % Generate a, b and c and mos and pairwise comparison matrices
    [pwc_mat,mos_mat,a_gen,b_gen,c_gen] = gen_data(Q_true,params);
    
    % Unify the scores 
    [Q_mixing, a, b, c] = mixing(pwc_mat, mos_mat, params.dataset_sizes);
    
    RMSE = RMSE + sqrt(mean((Q_true(2:end) - Q_mixing(2:end)').^2));
end

Q_pwc = pw_scale(pwc_mat);
Q_mos = nanmean(mos_mat');

plot_results (params, Q_true, Q_mixing, Q_mos, Q_pwc)

SROCC = corr(Q_true(2:end)', Q_mixing(2:end), 'Type', 'Spearman');
RMSE = sqrt(mean((Q_true(2:end) - Q_mixing(2:end)').^2));
disp (['Spearman Rank Order Correlation: ', num2str(SROCC)])
disp (['Root Mean Squared Error: ', num2str(RMSE)])
