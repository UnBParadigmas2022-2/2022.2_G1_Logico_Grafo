FROM swipl
WORKDIR /app
COPY ./src /app
CMD ["swipl", "grafo.pl"]