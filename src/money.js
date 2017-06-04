const Fiat = require('./lib/Fiat');j

//request 1 USD
export const requestOnSubmit = () => {
  return Fiat.fetch().then((toEth) => {
    return toEth.USD(1);
  });
}

