import { Link } from 'react-router-dom'

function NotFound() {
  return (
    <section>
      <h1 className="text-3xl font-bold">Página no encontrada</h1>
      <p className="mt-2 text-stone-600">
        La ruta que buscas no existe.{' '}
        <Link to="/" className="text-orange-700 underline">
          Volver al inicio
        </Link>
      </p>
    </section>
  )
}

export default NotFound
