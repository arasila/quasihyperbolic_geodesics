% FILE widemarg.m begins.
% Creates wide margins for figure n
function widemarg(n)
figure(n)
ax=axis;
dx=0.07*(ax(2)- ax(1));
dy=0.07*(ax(4)- ax(3));
newax=[ ax(1)-dx ax(2)+dx ax(3)-dy ax(4)+dy];
axis(newax);
% FILE widemarg.m ends.
