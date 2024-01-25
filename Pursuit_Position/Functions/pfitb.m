function  [xpar mconf sconf xx Values] = pfitb(dat, varargin )
%pfitb Fit psychometric function with optional bootstrap
% 
% Karl R. Gegenfurtner (gegenfurtner@uni-giessen.de)
%
% input arguments:
%	dat: data array with three columns
%		stimulus levels
%		proportion X responses OR number of X responses
%		number of trials
%	varargin: variable number of options
%		'plot' (0): plot psychometric function
%		'n_intervals' (1): followed by numeric argument (1 = yesno, 2 = 2AFC etc)
%		'verbose' (0): print results
%		'guess' (1): estimate guess and lapse rate between 0 and 0.05
%		'boot' (0): run bootstrap estimate of confidence interval
%		'nboot' (200): followed by numeric argument specifying number of bootstrap runs
%		'shape' ('logistic'): followed by string argument specifying shape of
%			psychometric function, 'logistic' or 'gauss')
% output arguments
%	xpar: final parameter values, mean, sigma, optional guess, lapse
%	mconf: lower and upper bounds of 95% confidence interval for mean
%	sconf: lower and upper bounds of 95% confidence interval for sigma
%


lshape = 1;
guess0 = 0;
GuessLapse = 1;

mconf = [0, 0]; sconf = [0, 0];

xval = dat(:,1);
pobs = dat(:,2);
nobs = dat(:,3);
if max(pobs) > 1.0
	robs = pobs;
	pobs = robs./nobs;
else
	robs = round(pobs.*nobs);
end

DoPlot = 0;
nint = 1; % yes-no
verbose = 0;
nboot = 0;

for i=1:length(varargin)
    if strncmpi(varargin{i}, 'plot', 4)
        DoPlot = 1;
    elseif strcmpi(varargin{i}, 'n_intervals')
        i=i+1; nint = varargin{i};
    elseif strcmpi(varargin{i}, 'verbose')
        verbose = 1;
    elseif strcmpi(varargin{i}, 'quiet')
        verbose = 0;
    elseif strcmpi(varargin{i}, 'guess')
        GuessLapse = 1;
    elseif strcmpi(varargin{i}, 'noguess')
        GuessLapse = 0;
    elseif strcmpi(varargin{i}, 'boot')
        nboot = 200;
    elseif strcmpi(varargin{i}, 'nboot')
        i=i+1; nboot = varargin{i};
    elseif strcmpi(varargin{i}, 'shape')
        i=i+1; shape = char(varargin{i});    
        lshape = (strncmpi(shape, 'gauss', 3)) == 0;
    end
end

guess0 = 0.0;
if (nint > 1)
    guess0 = 1/nint;
end    

lapse = 0.0;
guess = 0.0;

% [xval robs nobs] = textread(fname);
guess_mue=mean(xval);
guess_sigma=std(xval);
guess_guess=guess;
guess_lapse=lapse;

x0(1) = guess_mue; x0(2) = guess_sigma; 
if GuessLapse
    x0(3)=guess_guess; 
    x0(4)=guess_lapse;
end

[xpar fval oflag] = fminsearch(@(x)Lsquares(x,xval,robs,nobs,lshape,guess0), x0);

if (oflag ~= 1)
    fprintf('FMINSEARCH PROBLEM %d\n', oflag);
end

mue=xpar(1);
sigma=xpar(2);
if GuessLapse
    if 1
        guess=(sin(xpar(3))+1)/2*0.05;
        lapse=(sin(xpar(4))+1)/2*0.05;
    else
        guess = xpar(3);
        lapse = xpar(4);
    end
end

if (verbose)
    if (GuessLapse)
        fprintf('fminsearch dev=%5.2f%% at mue=%f and sigma %f  guess %f lapse %f\n', sqrt(fval*100/length(nobs)), mue, sigma, guess, lapse);
    else
        fprintf('fminsearch dev=%5.2f%% at mue=%f and sigma %f\n', sqrt(fval*100/length(nobs)), mue,sigma);
    end
end

% xxx.params.est(1) = mue;
% xxx.params.est(2) = sigma;
% xxx.params.est(3) = guess0 + guess;
% xxx.params.est(4) = lapse;

% dbstop if error;

if DoPlot
%     figure(5);
    zz = (xval-mue)./sigma; zlo=-3.5; zhi = 3.5;
    if min(zz) < zlo
    	zlo = min(zz);
    end
    if max(zz) > zhi
    	zhi = max(zz);
    end

    z=zlo:0.1:zhi; xx=mue + sigma * z; pvval = guess0 + guess + (1-lapse-guess0-guess)* Lpredict((xx-mue)/sigma, lshape);
    
   Values = pvval; 
  
    
%    plot(xval, pobs, 'ob', 'MarkerSize', 15, 'MarkerFaceColor', 'b', 'LineWidth', 2);
%     scatter(xval, pobs, 20+nobs, 'b', 'fill');
    xlabel('Stimulus level'); ylabel('Proportion');
    h = ishold();
    hold on;
%     plot(xx, pvval, '-k', 'LineWidth', 3);
    if h==0
        hold off;
    end
end

if (nboot > 0)
    mval=zeros(nboot,1);sval=zeros(nboot,1);gval=zeros(nboot,1);lval=zeros(nboot,1);
    parfor i=1:nboot
        ndat = binornd(nobs, pobs);
        x0 = xpar; 
        [rpar] = fminsearch(@(x)Lsquares(x,xval,ndat,nobs,lshape,guess0), x0);
        mval(i) = rpar(1); sval(i) = rpar(2);
        if GuessLapse
            gval(i) = rpar(3); lval(i) = rpar(4);
        end
    end
    mconf = prctile(mval,[5 95]); sconf = prctile(sval,[5 95]);
    if verbose
        fprintf('mean %6f %6f %6f\n', mconf(1), xpar(1), mconf(2));        
        fprintf('std  %6f %6f %6f\n', sconf(1), xpar(2), sconf(2));
    end

%     if GuessLapse
%         gval2 = prctile(gval,[5 50 95]); lval2 = prctile(lval,[5 50 95]);
%     end
end

end
 

function [ loglike ] = Lsquares( X, xval, robs, nobs, lshape, guess0)
%Likeli Calculate log likelihood of Gaussian distribution

mue=X(1);
sigma=X(2);
if length(X) > 2
    if 1
        guess=(sin(X(3))+1)/2*0.05;
        lapse=(sin(X(4))+1)/2*0.05;
    else
        guess = X(3);
        lapse = X(4);
    end
else
    guess = 0.0;
    lapse = 0.0;
end

if lshape == 1
    pval = guess0 + guess + (1-lapse-guess0-guess)* (1 ./ (1 + exp(-(xval-mue)/sigma))); % LogitP((xval-mue)/sigma);
else
    pval = guess0 + guess + (1-lapse-guess0-guess)*  GaussP((xval-mue)/sigma);  % normcdf(xval, mue, sigma); % 
end    
loglike = sum(nobs .* (pval - robs./nobs).^2);
% fprintf('%f   %f %f %f %f\n', loglike, mue, sigma, guess, lapse);
end


function [ P ] = GaussP(z)
%GaussP cumulative probability og Gaussian distribution
%   Detailed explanation goes here

EPSILON = 1.0E-7;

x = abs(z);
t = 1.0./(1.0+0.33267*x);
r = exp(-(x.*x)/2.0) .* 0.398942280401433 .* (t .* (0.4361836 + t .* (-0.1201676 + t .* 0.9372980)));
fi = find(z<0.0);
r(fi) = 1.0-r(fi);
P = 1.0 - r;
end

function [ P ] = LogitP(z)
%GaussP cumulative probability og Gaussian distribution
%   Detailed explanation goes here

P = 1 ./ (1 + exp(-z));

end

function [ pval ] = Lpredict(z, lshape)
%Likeli Calculate log likelihood of Gaussian distribution

    if lshape == 1
        pval = 1 ./ (1 + exp(-z)); % LogitP((xval-mue)/sigma);
    else
        pval = GaussP(z);  % normcdf(xval, mue, sigma); % 
    end    

end

