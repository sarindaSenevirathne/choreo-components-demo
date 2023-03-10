const { Kafka } = require('kafkajs');

const kafka = new Kafka({
  clientId: 'my-app',
  brokers: ['4.tcp.ngrok.io:10962']
});

const consumer = kafka.consumer({ groupId: 'order-consumers' });
const producer = kafka.producer();

const ordersTopic = 'orders';
const paymentSuccessOrdersTopic = 'payment-success-orders';

async function consumeOrders() {
  await consumer.connect();
  await consumer.subscribe({ topic: ordersTopic, fromBeginning: true });

  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      const order = JSON.parse(message.value.toString());

      if (order.paymentStatus === 'SUCCESS') {
        console.log(`Received a successful order: ${JSON.stringify(order)}`);

        await producePaymentSuccessOrder(order);
      }
    }
  });
}

async function producePaymentSuccessOrder(order) {
  await producer.connect();
  await producer.send({
    topic: paymentSuccessOrdersTopic,
    messages: [{ value: JSON.stringify(order) }]
  });
}

consumeOrders();
