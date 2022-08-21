function [u_k, D] = patching(bornes_V_p,bornes_V_q_hat,u_k,D)

% Update u
d = D(bornes_V_p(1,:),bornes_V_p(2,:),:);
[r, c ] = ind2sub(size(d),find(d == 1));
for i = 1:length(r)
        u_k(bornes_V_p(1,r(i)),bornes_V_p(2,c(i)),:) = u_k(bornes_V_q_hat(1,r(i)),bornes_V_q_hat(2,c(i)),:);
end

% Update D
D(bornes_V_p(1,:),bornes_V_p(2,:),:) = 0;

end

