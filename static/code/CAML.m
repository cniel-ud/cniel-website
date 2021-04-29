function eta = CAML(logeta_init,DD,labels,Q)
% Copyright 2015 Austin J. Brockmeier
% ajbrockmeier at the domain of gmail.com

logbase=10;
[NN,d_x]=size(DD);
N=sqrt(NN);
if N^2~=NN
    error('reshaped distance matrix is not square');
end
L=bsxfun(@eq,labels(:),labels(:)');
L=L/trace(L);
oN=ones(N,1);
avec=oN/N;
nu=L*avec;
Lc=bsxfun(@minus,bsxfun(@minus,L,nu),nu')+avec'*nu;
objfungrad=@(X) my_objfungrad(X,DD,N,d_x,logbase,Lc);
options=[];
options.Display='off';
if Q>1
x0=logeta_init*(ones(d_x,Q)+(rand(d_x,Q)-.5)*.5);
else
x0=logeta_init*(ones(d_x,Q));
end

[logeta,~]=minFunc(objfungrad,x0(:),options);
eta=reshape(logbase.^logeta,d_x,[]);
end

function [f, gradf]= my_objfungrad(logeta,DD,N,d_x,logbase,Lc)
eta=reshape(logbase.^logeta,d_x,[]);
Ks=exp(-DD*eta);%this is by far the slowest part (N^2 D)
K=reshape(sum(Ks,2),N,N);
oN=ones(N,1);
avec=oN/N;
mu=K*avec;
Kc=bsxfun(@minus,bsxfun(@minus,K,mu),mu')+avec'*mu;
if any(isnan(K(:)))
    f=NaN;
    gradf=0*logeta;
else
    trKL=oN'*(Kc.*Lc)*oN;%    trKL=trace(K*H*L*H);%where H is centering matrix
    trKK=oN'*(Kc.^2)*oN;%    trKK=trace(K*H*K*H);
    f=-real(log(trKL)-log(trKK)/2);
    Grad_lk=Lc/trKL;%Lc=H*L*H
    Grad_k=Kc/trKK;%Kc=H*K*H
    Grad = Grad_lk-Grad_k;
    P = bsxfun(@times,Grad(:),Ks);
    gradf=reshape(real(P'*DD)',[],1)*log(logbase).*logbase.^logeta;
end

end


