local Particle = {}

Particle.enemyparticles = particles.enemy
Particle.sparkleparticles = particles.sparkle
Particle.stallerparticles = particles.staller
Particle.bulkparticles = particles.bulk
Particle.swivelparticles = particles.swivel
Particle.coinparticles = particles.coin
Particle.quantumparticles = particles.quantumparticles
local curid = 5000

function Particle:NewParticles(texture)
    if type(texture) ~= "userdata" then texture = HarpAPI.Texture:GetTexture(texture) end

    local part = NewParticles(texture,curid)
    curid = curid + 1
    return part
end

function Particle:Emit(particle,x,y,amount)
    if fancy then return end

    particle:setPosition(x, y)
	particle:emit(amount)
end

return Particle