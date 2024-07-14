object fifa {
    const partidos = []

    method agregarPartido(partido){
        partidos.add(partido)
    }
    method cuantasVecesJugo(eq1,eq2) = 
        partidos.count({p=> p.jugo(eq1) and p.jugo(eq2)})
}

class Partido {
    const equipo1
    const equipo2
    const jugadas = []

    method jugo(equipo) = equipo1 == equipo or equipo2 == equipo
    method adversario(equipo) =
        if (equipo1 == equipo) equipo2 else equipo1

    method goles(equipo) = 
        jugadas.count({j=>j.fueGol(equipo)})

    method gano(equipo) = 
        self.goles(equipo) > self.goles(self.adversario(equipo))  
    
    method fueMasEntretenido() = jugadas.count{j=>j.segundoTiempo()} > jugadas.size()/2

    method cuantasTarjetas(equipo) = jugadas.count{j=>j.sacaTarjeta(equipo)}
}

class Jugada {
    var minuto
    var property jugador
    method fueGol(e) = false

    method segundoTiempo() = minuto > 45

    method sacaTarjeta(equipo) = self.correspondeTarjeta() and self.esDelEquipo(equipo)
    
    method esDelEquipo(equipo) = jugador.esDelEquipo(equipo) 
    
    method correspondeTarjeta() = false
}

class JugadaFalta inherits Jugada{
    var intensidad
    var otroJugador

    override method correspondeTarjeta() = intensidad > 75 

}

class JugadaInsulto inherits Jugada{
    var insulto

    override method correspondeTarjeta() = insulto == "madre"

}

class JugadaPelea inherits Jugada{
    var otroJugador 
    override method esDelEquipo(equipo) = super(equipo) or otroJugador.esDelEquipo(equipo)
    method correspondeTarjeta() = true
}

class JugadaArco inherits Jugada{
   override method fueGol(equipo) = self.esDelEquipo(equipo)
}

class JugadaVar inherits JugadaArco {

    const circunstancias = []
    override method fueGol(equipo) = super(equipo) and elVar.golValido(self)

    method tieneCircunstancia(c) = circunstancias.contains(c)

    override method correspondeTarjeta() = self.tieneCircunstancia("Camiseta")
}
object elVar {
    var property modo = modoMasGoles
    method golValido(jugada) = modo.golValido(jugada)
}

object modoMasGoles {
    method golValido(jugada) = true
}

object modoFifa{
    method golValido(jugada) = jugada.jugador().esEstrella()
}

object modoJusticia{
    method golValido(jugada) = not self.hayCircunstanciaInvalida(jugada)

    method hayCircunstanciaInvalida(jugada) =
        jugada.tieneCircunstancia("Mano") or
        jugada.tieneCircunstancia("Adelantado") or
        jugada.tieneCircunstancia("No pasó")
}
class Jugador {
    var property equipo
    var property esEstrella = false
    method esDelEquipo(e) = equipo == e 
}