module test
include("particula.jl")
include("pso.jl")
"Ejemplos de prueba"
function suma(x)
    return sum(x)
end
a = particula.Particula(2,[1,2],suma)
println(a)
a.posicion = a.posicion + a.posicion
particula.actualiza_mejor_individual(a)
println("Cambio")
println(a)#Si cambia los fitness
a.posicion = [0,0]
particula.actualiza_mejor_individual(a)
println("Cambio")
println(a)#Si actualiza los mejores ss
a.empeora = 50
particula.debo_matar(a,10)
println(a)
println("Cambiando velocidad..")
mejor = particula.Particula(2,[1,1],suma)
particula.actualiza_velocidad(a,mejor)
println(a.velocidad)
println("Cambiando posicion..")
particula.actualiza_posicion(a)
println(a.posicion)
###PSO
p = pso.PSO(suma,10,[5.0,0.0])
#println(p)
println(pso.corre_pso(10000, p))
#println(arbol[1])
#println(obten_peso_total(arbol))
#arbol_2= obten_arbol_con_punto(arbol,[1.87,0])
#println(arbol_2[1])
#println(obten_peso_total(arbol_2))
#Tiempo con 900 iteraciones 150 swarms y 150 particulas por cada swarm =
end
