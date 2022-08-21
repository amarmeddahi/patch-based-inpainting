function delta_D = border(D)

% Morphologic transformation :
SE = strel('diamond',1);

% Border of the mask area (containing 1):
delta_D = D - imerode(D,SE);
