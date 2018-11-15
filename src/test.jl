module test
include("particula.jl")
include("pso.jl")
"Ejemplos de prueba"
function suma(x)
    return sum(x)
end
a = particula.Particula(4,[1,2,6,9],suma)
println(a)
a.posicion = a.posicion + a.posicion
particula.actualiza_mejor_individual(a)
println("Cambio")
println(a)#Si cambia los fitness
a.posicion = [0,0,0,0]
particula.actualiza_mejor_individual(a)
println("Cambio")
println(a)#Si actualiza los mejores ss
a.empeora = 50
particula.debo_matar(a,10)
println(a)
println("Cambiando velocidad..")
mejor = particula.Particula(4,[1,1,1,1],suma)
particula.actualiza_velocidad(a,mejor)
println(a.velocidad)
println("Cambiando posicion..")
particula.actualiza_posicion(a)
println(a.posicion)
###PSO
p = pso.PSO(suma,10,[0.0,0.0])
println(p)
println(pso.corre_pso(30, p))
end
