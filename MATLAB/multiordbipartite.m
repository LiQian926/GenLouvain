function [B,twomu] = multiordbipartite(A,gamma,omega)
% MULTIORDBIPARTITE [B,twomu] = MULTIORDBIPARTITE(A,gamma,omega)
%
% Input: A: Cell array of MxN adjacncy matrices for each layer of a
%           multilayer undirected bipartite network
%        gamma: resolution parameter
%        omega: interlayer coupling strength
%
% Output: B: [(M+N)xT]x[(M+N)xT] flattened modularity tensor for the
%            multilayer bipartite network with ordinal coupling (T is
%            the number of layers of the network)
%         twomu: normalisation constant
%
% Usage: [B,twomu]=multiordbipartite(A,gamma,omega);
%        [S,Q]=genlouvain(B);
%        Q=Q/twom;
%        S=reshape(S,M+N,T);
%
% References: 
%       Barber, M. Modularity and community detection in bipartite networks. 
%           Phys. Rev. E 76, 066102 (2007).
%
%       Mucha, P. J., Richardson, T., Macon, K., Porter, M. A. & Onnela, J.-P. 
%           Community structure in time-dependent, multiscale, and multiplex networks. 
%           Science 328, 876?878 (2010).
%
% Lucas Jeub
% jeub@maths.ox.ac.uk

[m,n]=size(A{1});
N=m+n;
T=length(A);
B=spalloc(N*T,N*T,2*m*n*T+2*N*T);
mu=0;
for s=1:T
    k=sum(A{s},2);
    d=sum(A{s},1);
    mm=sum(k);
    
    if mm==0
        B1=sparse(m,n);
    else
        B1=A{s}-gamma*k*d/mm;
    end
        
    indx=(s-1)*N;    
    B(indx+1:indx+m,indx+m+1:indx+N)=B1;
    B(indx+m+1:indx+N,indx+1:indx+m)=B1';
    
    mu=mm+mu;
   
end

B = B + omega*spdiags(ones(N*T,2),[-N,N],N*T,N*T);
twomu=2*mu+2*N*(T-1)*omega;
end
