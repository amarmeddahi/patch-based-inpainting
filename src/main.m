clear
close all
clc

% Screen settings :
screen_size = get(0,'ScreenSize');
L = screen_size(3);
H = screen_size(4);
figure('Name','Patching-Inpainting',...
	'Position',[0.06*L,0.1*H,0.9*L,0.75*H])

% Loading image :
image_path = 'randonneur.jpg';
u0 = double(imread(image_path));
[~,~,nb_channels] = size(u0);
u_max = max(u0(:));

% Showing image :
subplot(1,2,1)
	imagesc(max(0,min(1,u0/u_max)),[0 1])
	axis image off
	title('Original Image','FontSize',20)
	if nb_channels == 1
		colormap gray
	end

% Select the domain to restore :
disp('Select a polygone (double-clic to validate)')
[D,x_D,y_D] = roipoly();
for k = 1:length(x_D)-1
	line([x_D(k) x_D(k+1)],[y_D(k) y_D(k+1)],'Color','b','LineWidth',2);
end

% Showing result image :
u_k = u0;
for c = 1:nb_channels
	u_k(:,:,c) = (~D).*u_k(:,:,c);
end
subplot(1,2,2)
	imagesc(max(0,min(1,u_k/u_max)),[0 1])
	axis image off
	title('Result image','FontSize',20)
	if nb_channels == 1
		colormap gray
	end
drawnow nocallbacks

% Initialization of the border D :
delta_D = border(D);
indices_delta_D = find(delta_D > 0);
nb_points_delta_D = length(indices_delta_D);

% Parameters :
t = 9;			% Pixel neighborhood size (2t+1) x (2t+1)
T = 50;			% Search window size (2T+1) x (2T+1)

% While the border D is not empty:
while nb_points_delta_D > 0

	% Random pixel from the border :
	indice_p = indices_delta_D(randi(nb_points_delta_D));
	[i_p,j_p] = ind2sub(size(D),indice_p);

	% Looking for the pixel q_hat :
	[exist_q,bornes_V_p,bornes_V_q_hat] = d_min(i_p,j_p,u_k,D,t,T);

	% If there is at least one q pixel eligible :
	if exist_q

		% Patching and D update:
		[u_k,D] = patching(bornes_V_p,bornes_V_q_hat,u_k,D);

		% D update :
		delta_D = border(D);
		indices_delta_D = find(delta_D > 0);
		nb_points_delta_D = length(indices_delta_D);

		% Show image result :
		subplot(1,2,2)
		imagesc(max(0,min(1,u_k/u_max)),[0 1])
		axis image off
		title('Result image','FontSize',20)
		if nb_channels == 1
			colormap gray
		end
		drawnow nocallbacks
	end
end
