using Plots, LinearAlgebra, Random, Statistics
gr(size=(600,400))


x = [1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016] #Anos utilizados Anos X %Consumo
x1 = 2009:2020  #Anos utilizados em Anos X %Reservatório

y = [80300000, 83329500, 86285000, 89582710, 90906000, 91291000, 92855000, 92465000,   #Qtdde de água consumida
     91093000, 93626554, 92588000, 93744250,100011080, 103528800, 106171400, 108047380,
     108479780, 110984100, 106830880, 107527420]
z = [89.45, 99.1, 99.28, 93.48, 94.9, 90.05, 99.6, 101.49, 97.41, 90.58, 92.77, 53.72] #Porcentagem reservatórios

function regressao(x, y, F)         #regressão que será utilizada
    n, p = length(x), length(F)
    M = zeros(p, p)
    c = zeros(p)
    for j = 1:p
        for k = 1:p
            M[j,k] = sum(F[j](x[i]) * F[k](x[i]) for i = 1:n)
        end
        c[j] = sum(y[i] * F[j](x[i]) for i = 1:n)
    end
    Solution = M \ c
    mod(x) = sum(F[j](x) * Solution[j] for j = 1:p)
    return Solution, mod
end

F = [x->1, x -> x]   #1° modelo, Reta que mais se aproxima do Anos X Consumo

solucao, modelo = regressao(x, y, F)
y_pred = modelo.(x)
y_med = mean(y)
R2 = 1 - norm(y_pred - y)^2 / norm(y_med .- y)^2

scatter(x, y, c=:blue, ms=3, leg=false)
plot!(modelo, c=:red, lw=2, xlim = (1996,2020))
title!("R2 = $R2")

F = [x->1, x -> x, x->-x^2, x->x^3, x-> sin(2π/12 *x), x->cos(2π/12*x)]   #Modelo que melhor descreve Anos X Consumo que encontramos

solucao, modelo = regressao(x, y, F)
y_pred = modelo.(x)
y_med = mean(y)
R2 = 1 - norm(y_pred - y)^2 / norm(y_med .- y)^2

scatter(x, y, c=:blue, ms=3, leg=false)
plot!(modelo, c=:red, lw=2, xlim = (1996,2020))
title!("R2 = $R2")

F = [x -> 1, x-> x^2, x-> x^3, x-> sin(2π/4*x), x->cos(2π/4*x), x-> sin(2π/5*x), x->cos(2π/5*x), 
    x-> sin(2π/3*x), x->cos(2π/3*x), x-> sin(2π/7*x), x->cos(2π/7*x)]  #Modelo que descreve Anos X %Reservatórios 
                                                                   #(Encontramos com R2 melhor mas que não descrevia bem)

solucao, modelo = regressao(x1, z, F)
y_pred = modelo.(x1)
y_med = mean(z)
R2 = 1 - norm(y_pred - z)^2 / norm(y_med .- z)^2

scatter(x1,z, c=:blue, ms=3, leg=false) 
plot!(modelo, c=:red, lw=2, xlim = (2009,2020))
title!("R2 = $R2")

x2, z2 = x1[1:11], z[1:11]
solucao, modelo = regressao(x2, z2, F)  #Tirando o dado super baixo de 2020, percebemos que tal modelo não fica tão bom
y_pred = modelo.(x2)
y_med = mean(z2)
R2 = 1 - norm(y_pred - z2)^2 / norm(y_med .- z2)^2

scatter(x2,z2, c=:blue, ms=3, leg=false) 
plot!(modelo, c=:red, lw=2, xlim = (2009,2050))
title!("R2 = $R2")
