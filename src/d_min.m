function [exist_q,bornes_V_p,bornes_V_q_hat] = d_min(i_p,j_p,u_k,D,t,T)

% Computing the window F
[r,c,~] = size(u_k);
sub_rows_u = max(i_p - T, 1):min(i_p + T, r);
sub_cols_u = max(j_p - T, 1):min(j_p + T, c);
F = u_k(sub_rows_u,sub_cols_u,:);

% Computing the sub-window of D related to F
D = D(sub_rows_u,sub_cols_u);

% Neighborhood V(p)
sub_rows = max(i_p - t, 1):min(i_p + t, r);
sub_cols = max(j_p - t, 1):min(j_p + t, c);
bornes_V_p = [sub_rows ; sub_cols];
V_p = u_k(sub_rows,sub_cols,:);

% Initialization
[r_F,c_F,~] = size(F);
d_hat = sum(sqrt(sum((V_p - zeros(size(V_p))).^2,3)),'all');
exist_q = false;
bornes_V_q_hat = [];

% Looking for q_hat
for i = (t + 1):(r_F - t)
    for j = (t + 1):(c_F - t)

        % Computing of V_q
        sub_rows = max(i - t, 1):min(i + t, r_F);
        sub_cols = max(j - t, 1):min(j + t, c_F);
        V_q = F(sub_rows,sub_cols,:);
        V_d = D(sub_rows,sub_cols);

        % Check if there are pixel of V(q) in D
        if ~any(V_d(:) == 1)
            % Norm 
            n = sum(sqrt(sum((V_p - V_q).^2,3)),'all');
            if n < d_hat
                exist_q = true;
                i_q = sub_rows_u(i);
                j_q = sub_cols_u(j);
                sub_rows = max(i_q - t, 1):min(i_q + t, r);
                sub_cols = max(j_q - t, 1):min(j_q + t, c);
                bornes_V_q_hat = [sub_rows ; sub_cols];
            end
        end

    end
end

end

